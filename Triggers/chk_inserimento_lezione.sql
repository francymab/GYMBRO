CREATE OR REPLACE TRIGGER chk_inserimento_lezione
BEFORE INSERT ON Lezione_corso
FOR EACH ROW
DECLARE
	-- ECCEZIONI -- 
    -- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO" --      
    sede_exc EXCEPTION;
   	-- Questa eccezione viene lanciata nel caso in cui a compilare la scheda sia un dipendente che non è un istruttore -- 
	mansione_exc EXCEPTION; 
    -- Questa eccezione viene lanciata nel caso in cui si vuole assegnare ad una lezione un dipendente che non è di turno --
    dip_exc EXCEPTION;

	-- VARIABILI --
    stato_sedeX Sede.stato_sede%type;
	mansione_dip Dipendente.mansione%type;
	counter_dip NUMBER := 0;

BEGIN
    -- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" -- 
    SELECT stato_sede INTO stato_sedeX FROM Sede  
        WHERE via_sede = :NEW.fk_sala_via AND civico_sede = :NEW.fk_sala_civico AND cap_sede = :NEW.fk_sala_cap; 

    IF (stato_sedeX = 'NON ATTIVO') THEN 
        RAISE sede_exc; 
    END IF; 

    -- Reperiamo la mansione del dipendente che vuole compilare la scheda e controlliamo se non è licenziato -- 
    SELECT mansione INTO mansione_dip FROM dipendente WHERE fk_persona = :NEW.fk_dipendente AND data_di_licenziamento IS NULL; 

    -- Controlliamo se la mansione del dipendente è diversa da istruttore oppure null, per lanciare l'eccezione -- 
    IF(UPPER(mansione_dip) != 'ISTRUTTORE' OR mansione_dip IS NULL) THEN 
        RAISE mansione_exc; 
    END IF;

	-- Contiamo quante assegnazioni turno della settimana prossima ha il dipendente durante la fascia oraria della lezione che si vuole inserire --
	SELECT count(fk_dipendente) INTO counter_dip FROM Assegnazione_settimanale JOIN Tipologia_turno ON fk_tipologia_turno_nome = nome_tipologia_turno
        	WHERE fk_dipendente = :NEW.fk_dipendente AND TO_CHAR( data_assegnazione, 'DY' ) = :NEW.giorno_settimana_lezione 
        	AND data_assegnazione BETWEEN TRUNC(SYSDATE + 7,'D') + 1 AND TRUNC(SYSDATE + 7,'D') + 6
        	AND (:NEW.ora_inizio BETWEEN ora_inizio_turno AND ora_fine_turno AND :NEW.ora_fine BETWEEN ora_inizio_turno AND ora_fine_turno);

	-- Se il dipendente non è stato assegnato durante le ore della lezione, allora significa che durante quelle ore --
	-- il dipendente non è di turno --
	IF(counter_dip = 0) THEN
        RAISE dip_exc;
    END IF;

EXCEPTION
    WHEN sede_exc THEN      
        RAISE_APPLICATION_ERROR('-20121', 'LA SEDE NON È ATTIVA');    

    WHEN mansione_exc THEN  
        RAISE_APPLICATION_ERROR('-20122', 'LA MANSIONE DEL DIPENDENTE È DIVERSA DA ISTRUTTORE: ' || mansione_dip); 

	WHEN dip_exc THEN
        RAISE_APPLICATION_ERROR('-20123', 'IL DIPENDENTE ' || :NEW.fk_dipendente || ' NON È ASSEGNATO DURATE QUELLE ORE');
END;
