--CONTROLLO NUMERO LEZIONI GIORNALIERE--
create or replace TRIGGER chk_numero_lezione_giornaliere
BEFORE INSERT ON Lezione_corso 
FOR EACH ROW
DECLARE
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui venissero inserite più di 5 lezioni giornaliere per sede --
    lezioni_giornaliere_exc EXCEPTION;

    -- VARIABILI --
    numero_lezioni NUMBER := 0;
BEGIN 
    -- Contiamo quante lezioni sono disponibili nella sala in uno specifico giorno --
    SELECT COUNT(id_lezione) INTO numero_lezioni
        FROM Lezione_corso 
        WHERE giorno_settimana_lezione = :NEW.giorno_settimana_lezione AND fk_sala_via = :NEW.fk_sala_via
        AND fk_sala_cap = :NEW.fk_sala_cap AND fk_sala_civico = :NEW.fk_sala_civico;

    -- Se ci fossero più di 5 lezioni, allora lanciamo l'eccezione --
    IF (numero_lezioni >= 5) THEN
        RAISE lezioni_giornaliere_exc;
    END IF;

EXCEPTION
    WHEN lezioni_giornaliere_exc THEN
        RAISE_APPLICATION_ERROR('-20111', 'CI SONO GIÀ 5 LEZIONI PER QESTO GIORNO');
END;