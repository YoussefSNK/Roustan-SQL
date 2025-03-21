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

