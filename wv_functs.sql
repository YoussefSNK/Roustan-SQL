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

-- 2 : random_role() --

CREATE OR ALTER FUNCTION random_role(@id_party INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_players INT;
    DECLARE @wolf_count INT;
    DECLARE @wolf_quota FLOAT;
    DECLARE @next_role_id INT;
    
    SELECT @total_players = COUNT(*) 
    FROM players_in_parties
    WHERE id_party = @id_party;
    
    SELECT @wolf_count = COUNT(*) 
    FROM players_in_parties pip
    JOIN roles r ON pip.id_role = r.id_role
    WHERE pip.id_party = @id_party AND r.description_role = 'Loup-Garou';
    
    SET @wolf_quota = (@total_players + 1) * 0.33;
    
    -- Quota pour pouvoir être loup si ya pas trop de loups
    IF @wolf_count < @wolf_quota
    BEGIN
        -- 33% chance
        IF RAND() < 0.33
        BEGIN
            SELECT @next_role_id = id_role FROM roles WHERE description_role = 'Loup-Garou';
        END
        ELSE
        BEGIN
            SELECT TOP 1 @next_role_id = id_role 
            FROM roles 
            WHERE description_role <> 'Loup-Garou'
            ORDER BY NEWID();
        END
    END
    ELSE
    BEGIN
        SELECT TOP 1 @next_role_id = id_role 
        FROM roles 
        WHERE description_role <> 'Loup-Garou'
        ORDER BY NEWID();
    END
    
    RETURN @next_role_id;
END;
