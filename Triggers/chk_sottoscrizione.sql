CREATE OR REPLACE TRIGGER chk_sottoscrizione
BEFORE INSERT ON Sottoscrizione
FOR EACH ROW
DECLARE
    -- ECCEZIONI --    
    -- Questa eccezione viene lanciata nel caso in cui l'utente tenti di sottoscriversi ad una tipologia abbonamento --    
    -- che comprende un corso a cui è già sottoscritto --    
    sottoscrizione_exc EXCEPTION;    
    -- Questa eccezione viene lanciata nel caso in cui si raggiungesse il limite massimo di iscritti ad un corso --
    max_utenti_exc EXCEPTION; 

	-- CURSORI --
    -- Selezioniamo tutti i corsi compresi in una tipologia_abbonamento -- 
    CURSOR C  
    IS  
    SELECT fk_corso AS nome_c FROM Compreso WHERE fk_abbonamento_nome = :NEW.fk_abbonamento_nome; 
    
    -- VARIABILI --   
	utenti_corsoX NUMBER := 0; 
    count_corsi NUMBER := 0; 
	durata_abbonamento_sot Tipologia_abbonamento.durata_abbonamento%TYPE;

BEGIN
    -- Per ogni corso selezionato, contiamo quanti utenti, di una specifica sede, sono iscritti e hanno pagato --
    -- Se il count raggiungesse il numero 75, allora abbiamo raggiunto il limite di sottoscrizioni per quel corso --
	FOR rec IN C 
    LOOP 
        select count(fk_utente) INTO utenti_corsoX from sottoscrizione join compreso ON sottoscrizione.fk_abbonamento_nome = compreso.fk_abbonamento_nome 
        where fk_corso = rec.nome_c AND fk_sede_via = :NEW.fk_sede_via 
        AND fk_sede_cap = :NEW.fk_sede_cap AND fk_sede_civico = :NEW.fk_sede_civico
    	AND ha_pagato = 'S'; 
 
        IF (utenti_corsoX = 75) THEN 
            RAISE max_utenti_exc; 
        END IF; 
    END LOOP; 
    
	-- Contiamo quante volte appare il corso nei corsi compresi nella sottoscrizione dell'utente --    
    -- Se fosse maggiore di 0, allora vuol dire che l'utente si vuole iscrivere ad una tipologia --    
    -- abbonamento che comprende un corso a cui è già iscritto --    
	SELECT count(fk_corso) INTO count_corsi FROM Compreso WHERE fk_corso IN   
		(SELECT fk_corso FROM Sottoscrizione JOIN Compreso ON Sottoscrizione.fk_abbonamento_nome = Compreso.fk_abbonamento_nome WHERE fk_utente = :NEW.fk_utente GROUP BY fk_corso)    
    		AND fk_abbonamento_nome = :NEW.fk_abbonamento_nome; 
   
	IF(count_corsi > 0) THEN    
        RAISE sottoscrizione_exc;    
    END IF;        

    -- Reperiamo la durata dell'abbonamento a cui l'utente vuole sottoscriversi --
	SELECT durata_abbonamento INTO durata_abbonamento_sot FROM Tipologia_abbonamento WHERE nome_tipologia_abbonamento = :NEW.fk_abbonamento_nome;

	-- Inseriamo i dati relativi alla durata della sottoscrizione e la data fine sottoscrizione, ottenuta tramite la durata --
    -- più la data di oggi --
    :NEW.fk_abbonamento_durata := durata_abbonamento_sot;
	:NEW.data_fine_sottoscrizione := ADD_MONTHS(:NEW.data_inizio_sottoscrizione, durata_abbonamento_sot);

EXCEPTION    
    WHEN max_utenti_exc THEN 
        RAISE_APPLICATION_ERROR('-20113', 'NUMERO MASSIMO DI UTENTI ISCRITTI '); 
    WHEN sottoscrizione_exc THEN    
    	RAISE_APPLICATION_ERROR('-20116', 'LA NUOVA SOTTOSCRIZIONE COMPRENDE UN CORSO GIÀ SOTTOSCRITTO DALL''UTENTE ' || :NEW.fk_utente);  
END;
