-- VIEW: ALL_PLAYERS --


CREATE VIEW ALL_PLAYERS AS
SELECT TOP 100 PERCENT
    p.pseudo AS nom_du_joueur,
    COUNT(DISTINCT pp.id_party) AS nombre_de_parties_jouees,
    COUNT(DISTINCT pl.id_turn) AS nombre_de_tours_joues,
    MIN(pl.start_time) AS date_premiere_participation,
    MAX(pl.end_time) AS date_derniere_action
FROM
    players p
JOIN
    players_in_parties pp ON p.id_player = pp.id_player
JOIN
    players_play pl ON p.id_player = pl.id_player
GROUP BY
    p.pseudo
ORDER BY
    nombre_de_parties_jouees ASC,
	nombre_de_tours_joues ASC,
    date_premiere_participation ASC,
    date_derniere_action ASC,
    p.pseudo ASC;


