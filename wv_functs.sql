-- 1 : random_position() --

CREATE OR ALTER FUNCTION random_position(@nb_rows INT, @nb_cols INT, @id_party INT)
RETURNS TABLE
AS
RETURN
(
    WITH all_positions AS (

        SELECT 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS position_id,
            CHAR(64 + (number % @nb_cols) + 1) AS col,
            CAST(((number / @nb_cols) + 1) AS VARCHAR(10)) AS row
        FROM 
            master.dbo.spt_values
        WHERE 
            type = 'P' AND number < (@nb_rows * @nb_cols)
    ),
    used_positions AS (
        SELECT DISTINCT origin_position_col AS col, origin_position_row AS row
        FROM players_play pp
        JOIN turns t ON pp.id_turn = t.id_turn
        WHERE t.id_party = @id_party
        
        UNION
        
        SELECT DISTINCT target_position_col AS col, target_position_row AS row
        FROM players_play pp
        JOIN turns t ON pp.id_turn = t.id_turn
        WHERE t.id_party = @id_party
    )
    SELECT TOP 1 p.col, p.row
    FROM all_positions p
    LEFT JOIN used_positions u ON p.col = u.col AND p.row = u.row
    WHERE u.col IS NULL
    ORDER BY NEWID()
);

