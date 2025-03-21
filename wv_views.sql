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
