--PRENOTAZIONE PISCINA--
CREATE OR REPLACE PROCEDURE prenotazione_piscina(numero_utente CHAR, 
                                                 via_piscina VARCHAR2, 
                                                 civico_piscina VARCHAR2, 
                                                 cap_piscina NUMBER, 
                                                 numero_piscina NUMBER, 
                                                 data_prenotazione VARCHAR2) 
AS
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO" --     
    sede_exc EXCEPTION;

    -- VARIABILI --
    stato_sedeX Sede.stato_sede%TYPE;
    data_prenotazioneX TIMESTAMP := to_timestamp(data_prenotazione, 'DD-MM-YY HH24:MI');

BEGIN
    -- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" --
    SELECT stato_sede INTO stato_sedeX FROM Sede 
    WHERE via_sede = via_piscina AND civico_sede = civico_piscina AND cap_sede = cap_piscina;
    
    IF(stato_sedeX = 'NON ATTIVO') THEN
        RAISE sede_exc;
    END IF;

    -- Inseriamo i dati relativi alla prenotazione dell'utente iscritto --
    INSERT INTO Prenotazione VALUES(data_prenotazioneX, numero_utente, 
                                    numero_piscina, via_piscina, civico_piscina, 
                                    cap_piscina, 20.00);

EXCEPTION
    WHEN sede_exc THEN 
        RAISE_APPLICATION_ERROR('-20007', 'LA SEDE NON È ATTIVA');
END;