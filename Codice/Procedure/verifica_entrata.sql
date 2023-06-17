--VERIFICA ENTRATA--
CREATE OR REPLACE PROCEDURE verifica_entrata(numero_tessera_utente CHAR) AS
    -- CURSORE --
    -- Questo cursore seleziona tutti i pagamenti effettuati, e le relative scadenze, --
    -- di ogni sottoscrizione di uno specifico utente dato il numero tessera -- 
    CURSOR C IS 
        SELECT ha_pagato AS pagamento_cur, data_fine_sottoscrizione AS scadenza_cur 
        FROM Sottoscrizione JOIN UTENTE ON fk_utente = fk_persona 
        WHERE numero_tessera = numero_tessera_utente;

    -- VARIABILI
    info_utente C%rowtype;         
    counter_sottoscrizioni_scadute NUMBER := 0;         
    tot_sottoscrizioni NUMBER := 0;
    numero_documento Utente.fk_persona%type;         

BEGIN
    -- Ricaviamo il numero documento della persona per poter controllare successivamente le sue sottoscrizioni --
    SELECT fk_persona INTO numero_documento FROM Utente WHERE numero_tessera = numero_tessera_utente;
    
    -- Contiamo quante sono tutte le sottoscrizioni dell'utente --
    SELECT COUNT(id_sottoscrizione) INTO tot_sottoscrizioni FROM Sottoscrizione 
        WHERE fk_utente = numero_documento;         

    -- Per ogni sottoscrizione contenuta nel cursore, effettuiamo un controllo sulla sottoscrizione --
    -- Se la sottoscrizione non fosse stata pagata o risultasse scaduta, allora aumentiamo un counter --
    -- che simboleggia le sottoscrizioni scadute dell'utente --
    FOR info_utente IN C LOOP              
        IF(info_utente.pagamento_cur = 'N' OR info_utente.scadenza_cur <= SYSDATE) THEN         
            counter_sottoscrizioni_scadute := counter_sottoscrizioni_scadute + 1;     		     
        END IF;         
    END LOOP;         

    -- Se le sottoscrizioni scadute dell'utente fossero minori di tutti le sue sottoscrizioni, significa che --
    -- esiste qualche sottoscrizione in regola, per cui l'utente può entrare. Altrimenti, verrà notificato che --
    -- l'utente in questione non può entrare --
    IF(counter_sottoscrizioni_scadute < tot_sottoscrizioni) THEN         
        dbms_output.put_line('L''utente può entrare'); 
    ELSE         
        dbms_output.put_line('L''utente non può entrare');         
    END IF;         
END;
