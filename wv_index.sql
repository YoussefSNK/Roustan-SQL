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