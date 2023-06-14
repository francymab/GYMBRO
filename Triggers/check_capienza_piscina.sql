CREATE OR REPLACE TRIGGER TRIGGER check_capienza_piscina           
BEFORE INSERT ON Prenotazione          
FOR EACH ROW           
DECLARE           
    -- ECCEZIONI --  
    -- Questa eccezione viene lanciata nel caso in cui ci fossero troppo prenotazioni per una piscina, per la quale si è superata la capienza massima --  
    capienza_exc EXCEPTION;      

	-- VARIABILI --  
    numero_persone NUMBER := 0;      
    capienza_piscina NUMBER := 0;      

BEGIN
    -- Contiamo quanti utenti hanno prenotato la piscina nell'arco di -1 ora e +59 minuti a partire dalla nuova prenotazione che si vuole effettuare -- 
    SELECT COUNT(fk_utente) INTO numero_persone      
        FROM Prenotazione WHERE data_ora_prenotazione 
            BETWEEN (:NEW.data_ora_prenotazione - INTERVAL '1' HOUR) AND (:NEW.data_ora_prenotazione + INTERVAL '59' MINUTE)     
            AND fk_piscina_numero = :NEW.fk_piscina_numero AND fk_piscina_via = :NEW.fk_piscina_via      
            AND fk_piscina_cap = :NEW.fk_piscina_cap AND fk_piscina_civico = :NEW.fk_piscina_civico;      

	-- Reperiamo l'informazione riguardo la capienza della piscina --
    SELECT capienza INTO capienza_piscina FROM Piscina       
        WHERE numero_piscina = :NEW.fk_piscina_numero AND fk_sede_via = :NEW.fk_piscina_via      
        AND fk_sede_cap = :NEW.fk_piscina_cap AND fk_sede_civico = :NEW.fk_piscina_civico;      

	-- Controlliamo che le prenotazioni non superino la capienza massima della piscina --
    IF (numero_persone = capienza_piscina) THEN      
        RAISE capienza_exc;      
    END IF;      
EXCEPTION           
    WHEN capienza_exc THEN      
        RAISE_APPLICATION_ERROR('-20112', 'È STATA RAGGIUNTA GIÀ LA CAPIENZA MASSIMA PER QUELLA PISCINA NELLA DATA E ORA: ' || :NEW.data_ora_prenotazione);      
END; 
