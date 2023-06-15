CREATE OR REPLACE PROCEDURE sottoscrizione_utente (numero_persona   CHAR,   
                                                   nome_abbonamento VARCHAR2,   
                                                   via_sedeX         VARCHAR2,   
                                                   civico_sedeX      VARCHAR2,   
                                                   cap_sedeX         NUMBER,   
                                                   codice_fiscale   CHAR := NULL,   
                                                   data_di_nascita  VARCHAR2 := NULL,   
                                                   nome             VARCHAR2 := NULL,   
                                                   cognome          VARCHAR2 := NULL,   
                                                   genere           CHAR := NULL,   
                                                   via_persona      VARCHAR2 := NULL,   
                                                   civico_persona   VARCHAR2 := NULL,   
                                                   cap_persona      NUMBER := NULL,   
                                                   telefono_persona CHAR := NULL)    
    AS   
      	-- ECCEZIONI -- 
    	-- Questa eccezione viene lanciata nel caso in cui si voglia sottoscrivere l'utente ad una tipologia abbonamento a cui è già iscritto -- 
        sottoscrizione_exc EXCEPTION;   
	-- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO" --      
	sede_exc EXCEPTION;   
 
	-- VARIABILI -- 
        data_di_nascitaX DATE := TO_DATE ( data_di_nascita, 'DD-MM-YY' );   
        eta_persona NUMBER := TO_NUMBER ( months_between(trunc(sysdate), data_di_nascitaX) / 12 );   
 
        check_sot NUMBER := 0;   
        stato_sedeX Sede.stato_sede%type;   
    BEGIN   
     	-- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" -- 
        SELECT stato_sede INTO stato_sedeX FROM Sede    
            WHERE via_sede = via_sedeX AND civico_sede = civico_sedeX AND cap_sede = cap_sedeX;   
 
        IF (stato_sedeX = 'NON ATTIVO') THEN   
            RAISE sede_exc;   
        END IF;   
 
        -- Controlliamo se il codice fiscale in input e la data di nascita siano NULL --   
        -- Nel caso in cui non fossero NULL, vuol dire che si sta cercando di sottoscrivere una persona per la prima volta ad un abbonamento -- 
	-- In quanto in caso contrario, vuol dire che la persona è già presente e si vuole sottoscrivere ad un nuovo abbonamento -- 
        IF (codice_fiscale IS NOT NULL AND data_di_nascita IS NOT NULL) THEN   
            -- Inseriamo i dati relativi alla persona --   
            INSERT INTO persona    
                VALUES (   
                    numero_persona,   
                    nome,   
                    cognome,   
                    genere,   
                    codice_fiscale,   
                    data_di_nascitaX,   
                    eta_persona,   
                    via_persona,   
                    civico_persona,   
                    cap_persona,   
                    telefono_persona );   
        	-- Inseriamo l'utente associato alla persona appena creata --   
            	INSERT INTO Utente(fk_persona) VALUES ( numero_persona );   
        END IF;   
 
        -- Tramite un contatore controlliamo se esiste già una sottoscrizione dell'utente allo specifico abbonamento --   
        SELECT COUNT(id_sottoscrizione)   
        INTO check_sot   
        FROM sottoscrizione   
        WHERE fk_utente = numero_persona AND fk_abbonamento_nome = nome_abbonamento;   
 
        -- Se esiste avremo il contatore maggiore di 0 e mandiamo l'errore --   
        IF ( check_sot > 0 ) THEN   
            RAISE sottoscrizione_exc;   
        ELSE   
            -- Inseriamo la sottoscrizione --   
            INSERT INTO sottoscrizione ( 
                fk_utente,   
                fk_abbonamento_nome,   
                fk_sede_via,   
                fk_sede_civico,   
                fk_sede_cap)   
            VALUES (    
                numero_persona,   
                nome_abbonamento,  
                via_sedeX,   
                civico_sedeX,   
                cap_sedeX);   
        END IF;   
 
    EXCEPTION   
        WHEN sottoscrizione_exc THEN   
            raise_application_error('-20003', 'L''UTENTE È GIÀ SOTTOSCRITTO A:  ' || nome_abbonamento);   
 
        WHEN sede_exc THEN   
            raise_application_error('-20004', 'LA SEDE ' || via_sedeX || ', '|| civico_sedeX || ', '|| cap_sedeX || ' NON È ATTIVA');   
    END;
