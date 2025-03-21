CREATE PROCEDURE SEED_DATA
    @NB_PLAYERS INT,
    @PARTY_ID INT
AS
BEGIN
    DECLARE @max_turns INT;

    -- Logique pour déterminer le nombre maximum de tours
    SET @max_turns = (SELECT COUNT(*) FROM turns WHERE id_party = @PARTY_ID);

    -- Insérer des tours de jeu
    WHILE @max_turns > 0
    BEGIN
        INSERT INTO turns (id_party, start_time, end_time)
        VALUES (@PARTY_ID, GETDATE(), DATEADD(MINUTE, 10, GETDATE()));

        SET @max_turns = @max_turns - 1;
    END
END;

-- 2 : USERNAME_TO_UPPER --

CREATE PROCEDURE COMPLETE_TOUR
    @TOUR_ID INT,
    @PARTY_ID INT
AS
BEGIN
    -- Logique pour appliquer les déplacements et résoudre les conflits
    -- Ici, on suppose que les déplacements sont validés sans conflit
    UPDATE players_play
    SET action = 'completed'
    WHERE id_turn = @TOUR_ID AND id_party = @PARTY_ID;
END;

-- 3 : USERNAME_TO_LOWER --

CREATE OR ALTER PROCEDURE USERNAME_TO_LOWER
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE players
    SET pseudo = LOWER(pseudo);

END;
