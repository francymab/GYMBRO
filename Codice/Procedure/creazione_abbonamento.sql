--CREATE PROCEDURE

--CREAZIONE TIPOLOGIA ABBONAMENTO--
CREATE OR REPLACE PROCEDURE creazione_abbonamento(nome_tipologia_abbonamento VARCHAR2,
                                                  durata_abbonamento NUMBER,
                                                  costo_abbonamento NUMBER,
                                                  nome_corso1 VARCHAR2,
                                                  obiettivo1 VARCHAR2 := NULL,
                                                  nome_corso2 VARCHAR2 := NULL,
                                                  obiettivo2 VARCHAR2 := NULL,
                                                  nome_corso3 VARCHAR2 := NULL,
                                                  obiettivo3 VARCHAR2 := NULL,
                                                  nome_corso4 VARCHAR2 := NULL,
                                                  obiettivo4 VARCHAR2 := NULL)
    AS

    BEGIN
        -- Inserimento di una nuova tipologia abbonamento nella tabella "Tipologia_abbonamento" --
        INSERT INTO Tipologia_abbonamento VALUES (nome_tipologia_abbonamento, durata_abbonamento, costo_abbonamento);

        -- Si controlla che il primo corso da inserire non esista all'interno della tabella "Corso" --
		-- Se esiste, esso non verrà inserito nella tabella. Se non esiste, verrà inserito un nuovo corso
        INSERT INTO corso (nome_corso, obiettivo) 
            SELECT nome_corso1, obiettivo1 
            FROM dual 
            WHERE NOT EXISTS(SELECT * FROM corso WHERE nome_corso = nome_corso1);

        --Insertimento dell'associazione tra "Corso" e "Tipologia_abbonamento"--
        INSERT INTO Compreso VALUES (nome_corso1, nome_tipologia_abbonamento, durata_abbonamento);

        --Controllo per l'inserimento di nuovi corsi--
        IF (nome_corso2 IS NOT NULL) THEN
            --si controlla se il corso non esiste e nel caso lo si crea--
            INSERT INTO corso (nome_corso, obiettivo) 
                SELECT nome_corso2, obiettivo2 
                FROM dual 
                WHERE NOT EXISTS(SELECT * FROM corso WHERE nome_corso = nome_corso2);

            --si associa il corso alla tipologia abbonamento--
            INSERT INTO Compreso VALUES (nome_corso2, nome_tipologia_abbonamento, durata_abbonamento);
        END IF;

        --si controlla se si vuole aggiunge un ulteriore corso all'abbonamento--        
        IF (nome_corso3 IS NOT NULL) THEN
            --si controlla se il corso non esiste e nel caso lo si crea--
            INSERT INTO corso (nome_corso, obiettivo) 
                SELECT nome_corso3, obiettivo3 
                FROM dual 
                WHERE NOT EXISTS(SELECT * FROM corso WHERE nome_corso = nome_corso3);

            --si associa il corso alla tipologia abbonamento--
            INSERT INTO Compreso VALUES (nome_corso3, nome_tipologia_abbonamento, durata_abbonamento);
        END IF;

        --si controlla se si vuole aggiunge un ulteriore corso all'abbonamento--
        IF (nome_corso4 IS NOT NULL) THEN
            --si controlla se il corso non esiste e nel caso lo si crea--
            INSERT INTO corso (nome_corso, obiettivo) 
                SELECT nome_corso4, obiettivo4 
                FROM dual 
                WHERE NOT EXISTS(SELECT * FROM corso WHERE nome_corso = nome_corso4);

            --si associa il corso alla tipologia abbonamento--
            INSERT INTO Compreso VALUES (nome_corso4, nome_tipologia_abbonamento, durata_abbonamento);
        END IF;

    END;
    