--ID LEZIONE CORSO--
CREATE OR REPLACE TRIGGER id_lezione_trigger BEFORE
INSERT ON lezione_corso
FOR EACH ROW
BEGIN
    -- Inseriamo come nuovo id lezione il valore successivo della sequenza --
    :NEW.id_lezione := id_lezione_seq.NEXTVAL;
END;