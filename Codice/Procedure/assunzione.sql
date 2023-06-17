CREATE OR REPLACE PROCEDURE assunzione(numero_persona    CHAR,
                                       via_sedeX         VARCHAR2,
                                       civico_sedeX      VARCHAR2,
                                       cap_sedeX         NUMBER,
                                       codice_fiscale    CHAR,
                                       data_di_nascita   VARCHAR2,
                                       codice_ibanX      CHAR,
                                       mansioneX         VARCHAR2,
                                       nome              VARCHAR2 := NULL,
                                       cognome           VARCHAR2 := NULL,
                                       genere            CHAR := NULL,
                                       via_persona       VARCHAR2 := NULL,
                                       civico_persona    VARCHAR2 := NULL,
                                       cap_persona       NUMBER := NULL,
                                       telefono          CHAR := NULL,
                                       stipendioX        NUMBER := NULL,
                                       titolo_di_studioX VARCHAR2 :=NULL)
    AS
    	-- ECCEZIONI --
    	-- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO" --     
        sede_exc EXCEPTION;

        -- VARIABILI --
        chk_dipendente NUMBER;
        data_di_nascitaX DATE := TO_DATE ( data_di_nascita, 'DD-MM-YYYY' );

        stato_sedeX Sede.stato_sede%type;

    BEGIN
        -- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" --
        SELECT stato_sede INTO stato_sedeX FROM Sede 
            WHERE via_sede = via_sedeX AND civico_sede = civico_sedeX AND cap_sede = cap_sedeX;

        IF (stato_sedeX = 'NON ATTIVO') THEN
            RAISE sede_exc;
        END IF;

        -- Controlliamo se già esiste un dipendente all'interno della tabella "Dipendente" con il numero del documento passato in input --
        SELECT COUNT(fk_persona) INTO chk_dipendente FROM Dipendente WHERE fk_persona = numero_persona;

		-- Se esiste, allora si è fatta richiesta di aggiornare i dati relativi al dipendente, in particolare: --
		-- 1. Un possibile cambio di sede --
		-- 2. Un cambio di stipendio --
		-- 3. Una riassunzione --
		-- Infatti, se lo stipendio fosse a NULL, allora si sta cercando di cambiare i dati relativi a 1. e 3. --
		-- Caso in cui lo stipendo fosse diverso da NULL, allora si sta cercando di effettuare un aumento e, probabilmente, la 1. e la 3. --
        IF (chk_dipendente = 1) THEN
            IF(stipendioX IS NULL) THEN
                UPDATE Dipendente SET fk_sede_via = via_sedeX, 
                                      fk_sede_civico = civico_sedeX, 
                                      fk_sede_cap = cap_sedeX, 
                                      data_di_licenziamento = NULL,
                                      stipendio_mensile = DEFAULT
                WHERE fk_persona = numero_persona;
            ELSE
                UPDATE Dipendente SET fk_sede_via = via_sedeX, 
                                      fk_sede_civico = civico_sedeX, 
                                      fk_sede_cap = cap_sedeX, 
                                      data_di_licenziamento = NULL,
                                      stipendio_mensile = stipendioX
                WHERE fk_persona = numero_persona;
            END IF;
        ELSE
            -- Se il dipendente non esiste, allora si tratta di un'assunzione. Per cui inseriamo i dati relativi alla persona --
            -- e successivamente al dipendente --
            INSERT INTO persona (numero_documento_persona,
                                 nome_persona,
                                 cognome_persona,
                                 genere_persona,
                                 codice_fiscale_persona,
                                 data_di_nascita,
                                 via_persona,
                                 civico_persona,
                                 cap_persona,
                                 telefono_persona)
                VALUES (
                    numero_persona,
                    nome,
                    cognome,
                    genere,
                    codice_fiscale,
                    data_di_nascitaX,
                    via_persona,
                    civico_persona,
                    cap_persona,
                    telefono);

            IF(stipendioX IS NULL) THEN
                INSERT INTO Dipendente(fk_persona, 
                       codice_iban, 
                       mansione,  
                       titolo_di_studio, 
                       fk_sede_via, 
                       fk_sede_civico, 
                       fk_sede_cap)
                VALUES(numero_persona, 
                       codice_ibanX, 
                       mansioneX, 
                       titolo_di_studioX, 
                       via_sedeX, 
                       civico_sedeX, 
                       cap_sedeX);
            ELSE
                INSERT INTO Dipendente(fk_persona, 
                       codice_iban, 
                       mansione, 
                       stipendio_mensile, 
                       titolo_di_studio, 
                       fk_sede_via, 
                       fk_sede_civico, 
                       fk_sede_cap)
                VALUES(numero_persona, 
                       codice_ibanX, 
                       mansioneX, 
                       stipendioX, 
                       titolo_di_studioX, 
                       via_sedeX, 
                       civico_sedeX, 
                       cap_sedeX);
            END IF;
        END IF;
EXCEPTION
    WHEN sede_exc THEN      
        RAISE_APPLICATION_ERROR('-20007', 'LA SEDE NON È ATTIVA');
END;
