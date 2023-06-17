--COMPILA SCHEDA ALLENAMENTO--
CREATE OR REPLACE PROCEDURE compila_scheda( data_inizio_scheda VARCHAR2,
                                            data_fine_scheda VARCHAR2,
                                            fk_scheda_utente CHAR,
                                            fk_dipendente CHAR,
                                            numero_serie NUMBER,
                                            fk_esercizio VARCHAR2,
                                            peso NUMBER,
                                            numero_ripetizioni NUMBER,
                                            secondi_di_recupero NUMBER,
                                            numero_serie2 NUMBER := NULL,
                                            fk_esercizio2 VARCHAR2 := NULL,
                                            peso2 NUMBER := NULL,
                                            numero_ripetizioni2 NUMBER := NULL,
                                            secondi_di_recupero2 NUMBER := NULL,
                                            numero_serie3 NUMBER := NULL,
                                            fk_esercizio3 VARCHAR2 := NULL,
                                            peso3 NUMBER := NULL,
                                            numero_ripetizioni3 NUMBER := NULL,
                                            secondi_di_recupero3 NUMBER := NULL,
                                            numero_serie4 NUMBER := NULL,
                                            fk_esercizio4 VARCHAR2 := NULL,
                                            peso4 NUMBER := NULL,
                                            numero_ripetizioni4 NUMBER := NULL,
                                            secondi_di_recupero4 NUMBER := NULL,
                                            numero_serie5 NUMBER := NULL,
                                            fk_esercizio5 VARCHAR2 := NULL,
                                            peso5 NUMBER := NULL,
                                            numero_ripetizioni5 NUMBER := NULL,
                                            secondi_di_recupero5 NUMBER := NULL,
                                            numero_serie6 NUMBER := NULL,
                                            fk_esercizio6 VARCHAR2 := NULL,
                                            peso6 NUMBER := NULL,
                                            numero_ripetizioni6 NUMBER := NULL,
                                            secondi_di_recupero6 NUMBER := NULL,
                                            numero_serie7 NUMBER := NULL,
                                            fk_esercizio7 VARCHAR2 := NULL,
                                            peso7 NUMBER := NULL,
                                            numero_ripetizioni7 NUMBER := NULL,
                                            secondi_di_recupero7 NUMBER := NULL,
                                            numero_serie8 NUMBER := NULL,
                                            fk_esercizio8 VARCHAR2 := NULL,
                                            peso8 NUMBER := NULL,
                                            numero_ripetizioni8 NUMBER := NULL,
                                            secondi_di_recupero8 NUMBER := NULL,
                                            numero_serie9 NUMBER := NULL,
                                            fk_esercizio9 VARCHAR2 := NULL,
                                            peso9 NUMBER := NULL,
                                            numero_ripetizioni9 NUMBER := NULL,
                                            secondi_di_recupero9 NUMBER := NULL) 
    AS
    	-- ECCEZIONI --
    	-- Questa eccezione viene lanciata nel caso in cui a compilare la scheda sia un dipendente che non è un istruttore --
	mansione_exc EXCEPTION;

	-- VARIABILI --
        mansione_dip Dipendente.mansione%type;
        abbonamento_sala_utente Compreso%rowtype;
        data_inizio_schedaX DATE := TO_DATE ( data_inizio_scheda, 'DD-MM-YY' );
        data_fine_schedaX DATE := TO_DATE ( data_fine_scheda, 'DD-MM-YY' );

    BEGIN
        -- Effettuiamo un controllo sulla sottoscrizione dell'utente che comprenda il corso "sala" --
        -- La query più interna restituisce il nome degli abbonamenti dell'utente che sono stati pagati e che abbiano il certificato medico consegnato --
        -- La query esterna filtra dal risultato della query interna solo i corsi con il nome di "sala" --
        -- Se non esistesse, verrebbe lanciato un errore, impedendo il proseguimento della procedura --
        SELECT * INTO abbonamento_sala_utente FROM Compreso 
        WHERE Compreso.fk_abbonamento_nome 
        IN (SELECT fk_abbonamento_nome 
            FROM Sottoscrizione 
            WHERE fk_utente = fk_scheda_utente 
            AND UPPER(ha_pagato) = 'S' 
            AND UPPER(certificato_medico) = 'S') 
        AND LOWER(fk_corso) = 'sala';
        
	-- Reperiamo la mansione del dipendente che vuole compilare la scheda e controlliamo se non è licenziato --
        SELECT mansione INTO mansione_dip FROM dipendente WHERE fk_persona = fk_dipendente AND data_di_licenziamento IS NULL;

        -- Controlliamo se la mansione del dipendente è diversa da istruttore oppure null, per lanciare l'eccezione --
        IF(UPPER(mansione_dip) != 'ISTRUTTORE' OR mansione_dip IS NULL) THEN
            RAISE mansione_exc;
        END IF;

        -- Inserimento della nuova scheda aventi i dati dell'istruttore e dell'utente, a cui si vuole associare la scheda, insieme ai dati --
        -- relativi all'inizio della scheda e alla sua scadenza --
        INSERT INTO Scheda_di_allenamento VALUES(data_inizio_schedaX, fk_scheda_utente, fk_dipendente, data_fine_schedaX);

        -- Inserimento del primo esercizio --
		-- La tabella "Coniente" rappresenta i dati degli esercizi contenuti all'interno di una scheda di allenamento --
        INSERT INTO Contiene VALUES(numero_serie, data_inizio_schedaX, fk_scheda_utente, fk_esercizio, peso, numero_ripetizioni, secondi_di_recupero);

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie2 IS NOT NULL) AND (fk_esercizio2 IS NOT NULL) AND (secondi_di_recupero2 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie2, data_inizio_schedaX, fk_scheda_utente, fk_esercizio2, peso2, numero_ripetizioni2, secondi_di_recupero2);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie3 IS NOT NULL) AND (fk_esercizio3 IS NOT NULL) AND (secondi_di_recupero3 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie3, data_inizio_schedaX, fk_scheda_utente, fk_esercizio3, peso3, numero_ripetizioni3, secondi_di_recupero3);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie4 IS NOT NULL) AND (fk_esercizio4 IS NOT NULL) AND (secondi_di_recupero4 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie4, data_inizio_schedaX, fk_scheda_utente, fk_esercizio4, peso4, numero_ripetizioni4, secondi_di_recupero4);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie5 IS NOT NULL) AND (fk_esercizio5 IS NOT NULL) AND (secondi_di_recupero5 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie5, data_inizio_schedaX, fk_scheda_utente, fk_esercizio5, peso5, numero_ripetizioni5, secondi_di_recupero5);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie6 IS NOT NULL) AND (fk_esercizio6 IS NOT NULL) AND (secondi_di_recupero6 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie6, data_inizio_schedaX, fk_scheda_utente, fk_esercizio6, peso6, numero_ripetizioni6, secondi_di_recupero6);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie7 IS NOT NULL) AND (fk_esercizio7 IS NOT NULL) AND (secondi_di_recupero7 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie7, data_inizio_schedaX, fk_scheda_utente, fk_esercizio7, peso7, numero_ripetizioni7, secondi_di_recupero7);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie8 IS NOT NULL) AND (fk_esercizio8 IS NOT NULL) AND (secondi_di_recupero8 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie8, data_inizio_schedaX, fk_scheda_utente, fk_esercizio8, peso8, numero_ripetizioni8, secondi_di_recupero8);
        END IF;

        -- Controlliamo se i valori obbligatori non sono null inserendo poi l'esercizio --
        IF ((numero_serie9 IS NOT NULL) AND (fk_esercizio9 IS NOT NULL) AND (secondi_di_recupero9 IS NOT NULL)) THEN
            INSERT INTO Contiene 
            VALUES(numero_serie9, data_inizio_schedaX, fk_scheda_utente, fk_esercizio9, peso9, numero_ripetizioni9, secondi_di_recupero9);
        END IF;

    EXCEPTION
        WHEN mansione_exc THEN 
            RAISE_APPLICATION_ERROR('-20001', 'LA MANSIONE DEL DIPENDENTE È DIVERSA DA ISTRUTTORE: ' || mansione_dip);
    END;
