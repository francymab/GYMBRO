--CHECK DATA UTENZA--
CREATE OR REPLACE TRIGGER chk_data_utenza 
BEFORE INSERT ON Utenza 
FOR EACH ROW 
DECLARE 
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui la data scadenza dell'utenza risultasse minore della data odiera --
    data_scadenza_exc EXCEPTION; 

BEGIN 
    -- Controlliamo se la data scadenza da inserire è minore o uguale alla data odierna --
    IF(:NEW.data_scadenza <= SYSDATE) THEN 
        RAISE data_scadenza_exc; 
    END IF; 

EXCEPTION 
    WHEN data_scadenza_exc THEN 
        RAISE_APPLICATION_ERROR('-20108', 'LA DATA SCADENZA ' || :NEW.data_scadenza || ' < ' || SYSDATE); 
END;