--ID SCONTRINO SCONTRINO--
CREATE OR REPLACE TRIGGER id_scontrino_trigger BEFORE
INSERT ON scontrino
FOR EACH ROW
BEGIN
    -- Inseriamo come nuovo id scontrino il valore successivo della sequenza --
    :NEW.id_scontrino := id_scontrino_seq.NEXTVAL;
END;