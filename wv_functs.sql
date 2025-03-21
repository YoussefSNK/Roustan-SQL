-- 1 : random_position() --

CREATE FUNCTION random_position(@lines INT, @columns INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        FLOOR(RAND() * @lines) + 1 AS line,
        FLOOR(RAND() * @columns) + 1 AS column
);


-- 2 : random_role() --

CREATE FUNCTION random_role()
RETURNS INT
AS
BEGIN
    DECLARE @role INT;

    SET @role = CASE
                    WHEN RAND() < 0.5 THEN 1
                    ELSE 2
                END;

    RETURN @role;
END;


-- 3 : get_the_winner() --
CCREATE FUNCTION get_the_winner(@partyid INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.pseudo AS nom_du_joueur,
        r.description_role AS role,
        pr.title_party AS nom_de_la_partie,
        COUNT(pp.id_turn) AS nb_tours_joues,
        (SELECT COUNT(t2.id_turn) FROM turns t2 WHERE t2.id_party = pip.id_party) AS nb_total_tours,
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
    WHERE
        pip.id_party = @partyid
    GROUP BY
        p.pseudo, r.description_role, pr.title_party
);
