-- PK --

ALTER TABLE parties ALTER COLUMN id_party INT NOT NULL;
ALTER TABLE roles ALTER COLUMN id_role INT NOT NULL;
ALTER TABLE players ALTER COLUMN id_player INT NOT NULL;
ALTER TABLE turns ALTER COLUMN id_turn INT NOT NULL;

ALTER TABLE parties ADD CONSTRAINT pk_parties PRIMARY KEY (id_party);
ALTER TABLE roles ADD CONSTRAINT pk_roles PRIMARY KEY (id_role);
ALTER TABLE players ADD CONSTRAINT pk_players PRIMARY KEY (id_player);
ALTER TABLE turns ADD CONSTRAINT pk_turns PRIMARY KEY (id_turn);

ALTER TABLE players_in_parties ALTER COLUMN id_party INT NOT NULL;
ALTER TABLE players_in_parties ALTER COLUMN id_player INT NOT NULL;
ALTER TABLE players_play ALTER COLUMN id_player INT NOT NULL;
ALTER TABLE players_play ALTER COLUMN id_turn INT NOT NULL;

ALTER TABLE players_in_parties ADD CONSTRAINT pk_players_in_parties PRIMARY KEY (id_party, id_player);
ALTER TABLE players_play ADD CONSTRAINT pk_players_play PRIMARY KEY (id_player, id_turn);


-- FK ---

ALTER TABLE players_in_parties
ADD CONSTRAINT FK_players_in_parties_parties FOREIGN KEY (id_party) REFERENCES parties(id_party);

ALTER TABLE players_in_parties
ADD CONSTRAINT FK_players_in_parties_players FOREIGN KEY (id_player) REFERENCES players(id_player);

ALTER TABLE players_in_parties
ADD CONSTRAINT FK_players_in_parties_roles FOREIGN KEY (id_role) REFERENCES roles(id_role);

ALTER TABLE turns
ADD CONSTRAINT FK_turns_parties FOREIGN KEY (id_party) REFERENCES parties(id_party);

ALTER TABLE players_play
ADD CONSTRAINT FK_players_play_players FOREIGN KEY (id_player) REFERENCES players(id_player);

ALTER TABLE players_play
ADD CONSTRAINT FK_players_play_turns FOREIGN KEY (id_turn) REFERENCES turns(id_turn);

-- modification de text en varchar --

ALTER TABLE players
ALTER COLUMN pseudo VARCHAR(255);

ALTER TABLE players_in_parties
ALTER COLUMN is_alive VARCHAR(255);

-- index --

CREATE INDEX idx_players_pseudo ON players(pseudo);
CREATE INDEX idx_players_in_parties_id_party ON players_in_parties(id_party);
CREATE INDEX idx_players_in_parties_id_player ON players_in_parties(id_player);
CREATE INDEX idx_turns_id_party ON turns(id_party);
CREATE INDEX idx_players_play_id_player ON players_play(id_player);
CREATE INDEX idx_players_play_id_turn ON players_play(id_turn);

-- contrainte vérification -- 

ALTER TABLE players_in_parties
ADD CONSTRAINT CHK_is_alive CHECK (is_alive IN ('true', 'false'));
