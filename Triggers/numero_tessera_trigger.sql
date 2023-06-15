--NUMERO TESSERA UTENTE--
CREATE OR REPLACE TRIGGER numero_tessera_trigger BEFORE
INSERT ON utente
FOR EACH ROW
BEGIN
    -- Inseriamo come nuovo numero tessera il valore successivo della sequenza --
    :NEW.numero_tessera := numero_tessera_seq.NEXTVAL;
END;