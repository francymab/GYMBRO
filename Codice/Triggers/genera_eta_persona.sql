--CALCOLO E CONTROLLO ETA--
CREATE OR REPLACE TRIGGER genera_eta_persona
BEFORE INSERT ON Persona
FOR EACH ROW
DECLARE
	-- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui l'utente non soddisfa i requisiti di età minima e massima per iscriversi --
    eta_exc EXCEPTION;

    -- VARIABILI --
    eta_massima NUMBER := 100;
    eta_minima NUMBER := 6;
    eta NUMBER;
    
BEGIN
    -- Otteniamo, dalla data di nascita della persona, la sua età --
    eta := TO_NUMBER ( months_between(trunc(sysdate), :NEW.data_di_nascita) / 12 );

	-- Controlliamo se non è compresa tra l'età minima e l'età massima per impedire l'inserimento della persona --
    IF (eta NOT BETWEEN eta_minima AND eta_massima) THEN
        RAISE eta_exc;
    END IF;

	-- Inseriamo l'età della persona -- 
    :NEW.eta_persona := eta;
    
EXCEPTION
    WHEN eta_exc THEN
        RAISE_APPLICATION_ERROR('-20103', 'ETA NON CONSENTITA PER L''ISCRIZIONE ALLA PALESTRA');
END;