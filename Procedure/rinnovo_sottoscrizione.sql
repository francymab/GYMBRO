--RINNOVO SOTTOSCRIZIONE--
CREATE OR REPLACE PROCEDURE rinnovo_sottoscrizione(numero_utente CHAR, 
                                                   nome_abbonamento VARCHAR2, 
                                                   via_sede VARCHAR2 := NULL, 
                                                   civico_sede VARCHAR2 := NULL, 
                                                   cap_sede NUMBER := NULL) 
AS 
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui si sta cercando di rinnovare una sottoscrizione che non ha bisogno di un rinnovo --
    pagamento_exc EXCEPTION;
    -- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO" --     
    sede_exc EXCEPTION;

    -- VARIABILI --
    sottoscrizione_pagata Sottoscrizione.ha_pagato%TYPE; 
    stato_sedeX Sede.stato_sede%type;

    BEGIN
        -- Reperiamo le informazioni relativi al pagamento della sottoscrizione da parte dell'utente --
        -- Se fosse "S" vuol dire che la sottoscrizione risulta pagata, per cui questa sottoscrizione non può essere rinnovata --
        SELECT ha_pagato INTO sottoscrizione_pagata FROM Sottoscrizione 
        WHERE fk_utente = numero_utente AND fk_abbonamento_nome = nome_abbonamento; 
        
        IF(sottoscrizione_pagata = 'S') THEN 
            RAISE pagamento_exc; 
        END IF; 

	-- Se i dati relativi all'indirizzo della sede fossero NULL, significherebbe che si sta cercando di rinnovare la sottoscrizione --
        -- nella sede da cui è stata inserita la prima volta. Per cui, in questo caso, verrà rinnovata la sottoscrizione, senza aggiornare
        -- i dati reletavi a dove è avvenuto il rinnovo --
        IF(via_sede IS NULL AND civico_sede IS NULL AND cap_sede IS NULL) THEN 
            UPDATE Sottoscrizione SET ha_pagato = 'S' 
                WHERE fk_utente = numero_utente AND fk_abbonamento_nome = nome_abbonamento; 
        ELSE 
            -- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" --
            SELECT stato_sede INTO stato_sedeX FROM Sede WHERE Sede.via_sede = via_sede AND
                                      Sede.civico_sede = civico_sede AND Sede.cap_sede = cap_sede;
            IF (stato_sedeX = 'NON ATTIVO') THEN
                RAISE sede_exc;
            END IF;

	    -- Dopo aver controllato che la sede è attiva, il rinnovo verrà effettuato tenendo conto della nuova sede --
            -- da cui è avvenuta la richiesta --
            UPDATE Sottoscrizione SET ha_pagato = 'S', fk_sede_via = via_sede, 
                                      fk_sede_civico = civico_sede, fk_sede_cap = cap_sede 
            WHERE fk_utente = numero_utente AND fk_abbonamento_nome = nome_abbonamento; 
        END IF; 
    
    EXCEPTION 
        WHEN pagamento_exc THEN 
            RAISE_APPLICATION_ERROR('-20005', 'LA SOTTOSCRIZIONE ( ' || nome_abbonamento || ' ) DI ' || numero_utente || ' RISULTA PAGATA');     
        WHEN sede_exc THEN 
            RAISE_APPLICATION_ERROR('-20006', 'LA SEDE NON È ATTIVA');     
END;