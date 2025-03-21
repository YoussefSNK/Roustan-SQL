-- VIEW: ALL_PLAYERS --


CREATE VIEW ALL_PLAYERS AS
SELECT
    p.pseudo AS nom_du_joueur,
    COUNT(DISTINCT pip.id_party) AS nombre_de_parties_jouees,
    COUNT(pp.id_turn) AS nombre_de_tours_joues,
    MIN(pp.start_time) AS date_premiere_participation,
    MAX(pp.end_time) AS date_derniere_action
FROM
    players p
JOIN
    players_in_parties pip ON p.id_player = pip.id_player
JOIN
    players_play pp ON p.id_player = pp.id_player
GROUP BY
    p.pseudo;

-- VIEW: ALL_PLAYERS_ELAPSED_GAME --

CREATE VIEW ALL_PLAYERS_ELAPSED_GAME AS
SELECT
    p.pseudo AS nom_du_joueur,
    pr.title_party AS nom_de_la_partie,
    COUNT(DISTINCT pip.id_player) AS nombre_de_participants,
    MIN(pp.start_time) AS date_premiere_action,
    MAX(pp.end_time) AS date_derniere_action,
    SUM(DATEDIFF(SECOND, pp.start_time, pp.end_time)) AS nb_secondes_passees
FROM
    players p
JOIN
    players_in_parties pip ON p.id_player = pip.id_player
JOIN
    parties pr ON pip.id_party = pr.id_party
JOIN
    players_play pp ON p.id_player = pp.id_player
GROUP BY
    p.pseudo, pr.title_party;

-- VIEW: ALL_PLAYERS_ELAPSED_TOUR --

CREATE VIEW ALL_PLAYERS_ELAPSED_TOUR AS
SELECT
    p.pseudo AS nom_du_joueur,
    pr.title_party AS nom_de_la_partie,
    pp.id_turn AS numero_du_tour,
    t.start_time AS date_debut_du_tour,
    pp.end_time AS date_prise_decision,
    DATEDIFF(SECOND, t.start_time, pp.end_time) AS nb_secondes_passees
FROM
    players p
JOIN
    players_in_parties pip ON p.id_player = pip.id_player
JOIN
    parties pr ON pip.id_party = pr.id_party
JOIN
    players_play pp ON p.id_player = pp.id_player
JOIN
    turns t ON pp.id_turn = t.id_turn;


-- VIEW: ALL_PLAYERS_STATS --

CREATE VIEW ALL_PLAYERS_STATS AS
SELECT
    p.pseudo AS nom_du_joueur,
    r.description_role AS role,
    pr.title_party AS nom_de_la_partie,
    COUNT(pp.id_turn) AS nb_tours_joues,
    (SELECT COUNT(t2.id_turn) FROM turns t2 WHERE t2.id_party = pip.id_party) AS nb_total_tours,
    CASE
        WHEN r.description_role = 'loup' THEN 'Villageois éliminés'
        ELSE 'Survivant'
    END AS vainqueur,
    AVG(DATEDIFF(SECOND, t.start_time, pp.end_time)) AS temps_moyen_prise_decision
FROM
    players p
JOIN
    players_in_parties pip ON p.id_player = pip.id_player
JOIN
    roles r ON pip.id_role = r.id_role
JOIN
    parties pr ON pip.id_party = pr.id_party
JOIN
    players_play pp ON p.id_player = pp.id_player
JOIN
    turns t ON pp.id_turn = t.id_turn
GROUP BY
    p.pseudo, r.description_role, pr.title_party, pip.id_party;
