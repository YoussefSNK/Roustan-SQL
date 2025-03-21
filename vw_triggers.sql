-- trigger 1 -- 

CREATE TRIGGER trg_complete_tour
ON turns
AFTER UPDATE
AS
BEGIN
    DECLARE @turn_id INT;
    DECLARE @party_id INT;

    SELECT @turn_id = id_turn, @party_id = id_party
    FROM inserted;

    -- Appel de la procédure COMPLETE_TOUR
    EXEC COMPLETE_TOUR @turn_id, @party_id;
END;

