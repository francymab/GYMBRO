--SEDE NON ATTIVA--
CREATE OR REPLACE TRIGGER sede_non_attiva  
BEFORE UPDATE OF stato_sede ON Sede
FOR EACH ROW
DECLARE
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui ci fossero ancora delle utenze da pagare nella sede che si vuole dichiare nello stato di "NON ATTIVO"
    utenze_exc EXCEPTION;

    -- VARIABILI --
    chk_utenze NUMBER := 0;

BEGIN 
    -- Contiamo quante utenze ci sono ancora da pagare nella sede che si vuole cambiare lo stato in "NON ATTIVO" --
    -- Se fosse maggiore di 0, allora vanno pagate delle utenze e non si può aggiornare la sede --
    SELECT COUNT(numero_fattura) INTO chk_utenze FROM Utenza  WHERE fk_sede_via = :NEW.via_sede
            AND fk_sede_civico = :NEW.civico_sede AND fk_sede_cap = :NEW.cap_sede AND pagamento_utenza = 'N';

    IF (chk_utenze > 0) THEN
        RAISE utenze_exc;
    END IF;

    IF(UPPER(:NEW.stato_sede) = 'NON ATTIVO') THEN 
        UPDATE Dipendente SET data_di_licenziamento = sysdate WHERE fk_sede_via = :NEW.via_sede
            AND fk_sede_civico = :NEW.civico_sede AND fk_sede_cap = :NEW.cap_sede; 
    END IF; 

    EXCEPTION
        WHEN utenze_exc THEN
            RAISE_APPLICATION_ERROR('-20107', 'ESISTONO ANCORA DELLE UTENZE DA PAGARE');
END;