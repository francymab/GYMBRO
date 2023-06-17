CREATE OR REPLACE TRIGGER chk_utente_prenotato  
BEFORE INSERT ON PRENOTAZIONE   
FOR EACH ROW  
DECLARE
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui l'utente tenti di prenotarsi negli orari compresi in una sua prenotazione già effettuata --
    -- ora prima di una sua prenotazione, in quanto non vogliamo che l'utente possa sovrapporre gli orari di prenotazione --
    prenotazione_exc EXCEPTION;  

	-- VARIABILI --
    count_prenotazione NUMBER := 0; 

BEGIN   
    -- Contiamo quante prenotazioni ha già effettuato l'utente in quella piscina che partono dall'orario selezionato -1 ora e +1 ora --
    SELECT COUNT(fk_utente) INTO count_prenotazione FROM Prenotazione   
        WHERE fk_utente = :NEW.fk_utente AND  
        data_ora_prenotazione BETWEEN (:NEW.data_ora_prenotazione - INTERVAL '1' HOUR) AND (:NEW.data_ora_prenotazione + INTERVAL '1' HOUR) 
            AND fk_piscina_numero = :NEW.fk_piscina_numero AND fk_piscina_via = :NEW.fk_piscina_via      
            AND fk_piscina_cap = :NEW.fk_piscina_cap AND fk_piscina_civico = :NEW.fk_piscina_civico;  

    -- Se è presente una prenotazione, significa che l'utente potrebbe sovrapporre la prenotazione ad una già effettuata --
    IF (count_prenotazione > 0) THEN  
        RAISE prenotazione_exc;  
    END IF;  
 
EXCEPTION  
    WHEN prenotazione_exc THEN  
        RAISE_APPLICATION_ERROR('-20114', 'L'' UTENTE HA GIÀ EFFETTUATO LA PRENOTAZIONE NELLA STESSA PISCINA NELL''ARCO DI 1H');  
END;
