--ID SOTTOSCRIZIONE UTENTE--
CREATE OR REPLACE TRIGGER id_sottoscrizione_trigger BEFORE
INSERT ON sottoscrizione
FOR EACH ROW
BEGIN
    -- Inseriamo come nuovo id sottoscrizione il valore successivo della sequenza --
    :NEW.id_sottoscrizione := id_sottoscrizione_seq.NEXTVAL;
END;