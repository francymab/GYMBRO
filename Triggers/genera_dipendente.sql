--CONTROLLO SUL DIPENDENTE--
create or replace trigger genera_dipendente
BEFORE INSERT ON Dipendente
FOR EACH ROW
DECLARE
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui il dipendente sia minorenne, impendendo il suo inserimento --
    eta_exc EXCEPTION;
    -- Questa eccezione viene lanciata nel caso in cui si fosse raggiunto il massimo delle mansioni consentite per sede --
    tipo_dip_exc EXCEPTION;
    -- Questa eccezione viene lanciata nel caso in cui si fosse raggiunto il limite di dipendenti per sede --
    tot_dip_exc EXCEPTION;

    -- VARIABILI --
    eta_dip NUMBER;
    count_dip NUMBER :=0;
BEGIN
    -- Ricaviamo l'età del dipendente. Se essa fosse minore di 18, lanciamo l'eccezione --
    SELECT eta_persona INTO eta_dip FROM Persona WHERE numero_documento_persona = :NEW.fk_persona;

    IF (eta_dip < 18) THEN
        RAISE eta_exc;
    END IF;

    -- Contiamo quante mansioni dello stesso tipo sono già presenti nella sede in cui vogliamo inserire il nuovo dipendente --
    -- Se fossero già presenti 3 istruttori, allora impendiamo l'inserimento --
    -- Se fossero già presenti 2 segretarie, allora impendiamo l'inserimento --
    -- Se fossero già presente 1 responsabile, allora impendiamo l'inserimento --
    SELECT COUNT(mansione) INTO count_dip FROM Dipendente 
        WHERE mansione = :NEW.mansione AND fk_sede_via = :NEW.fk_sede_via 
            AND fk_sede_civico = :NEW.fk_sede_civico AND fk_sede_cap = :NEW.fk_sede_cap;

    IF(UPPER(:NEW.mansione) = 'ISTRUTTORE' AND count_dip = 3) THEN
        RAISE tipo_dip_exc;
    ELSIF (UPPER(:NEW.mansione) = 'SEGRETARIA' AND count_dip = 2) THEN
        RAISE tipo_dip_exc;
    ELSIF (UPPER(:NEW.mansione) = 'RESPONSABILE' AND count_dip = 1) THEN
        RAISE tipo_dip_exc;
    END IF;

    -- Contiamo quanti dipendenti sono stati assunti nella sede dove si vuole inserire il nuovo dipendente --
    -- Se ci fossero 6 dipendenti, allora la sede è piena e impendiamo l'inserimento --
    SELECT COUNT(fk_persona) INTO count_dip FROM Dipendente 
        WHERE fk_sede_via = :NEW.fk_sede_via AND fk_sede_civico = :NEW.fk_sede_civico 
            AND fk_sede_cap = :NEW.fk_sede_cap;

    IF(count_dip = 6) THEN
        DELETE FROM Persona WHERE numero_documento_persona = :NEW.fk_persona;
        RAISE tot_dip_exc;
    END IF;

EXCEPTION
    WHEN eta_exc THEN
        RAISE_APPLICATION_ERROR('-20104', 'ETA DEL DIPENDENTE MINORE DI 18 ');
    WHEN tipo_dip_exc THEN
        RAISE_APPLICATION_ERROR('-20105', 'CI SONO GIÀ ' || count_dip ||' '|| :NEW.mansione|| ' NELLA SEDE SELEZIONATA');
    WHEN tot_dip_exc THEN
        RAISE_APPLICATION_ERROR('-20106', 'CI SONO GIÀ 6 NELLA SEDE SELEZIONATA');
END;