--CONTROLLO DATA PRENOTAZIONE--
CREATE OR REPLACE TRIGGER chk_data_prenotazione
BEFORE INSERT ON Prenotazione 
FOR EACH ROW
DECLARE
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui la data della prenotazione risultasse minore della data odierna --
    date_exc EXCEPTION;

BEGIN 
    -- Controlliamo se la data della prenotazione è minore della data odierna --
    IF (:NEW.data_ora_prenotazione < CURRENT_TIMESTAMP) THEN
        RAISE date_exc;
    END IF;

EXCEPTION
    WHEN date_exc THEN
        RAISE_APPLICATION_ERROR('-20110', 'DATA ED ORA INIZIO MINORI DI: ' || CURRENT_TIMESTAMP);
END;
