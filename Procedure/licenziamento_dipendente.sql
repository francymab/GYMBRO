--LICENZIAMENTO--
CREATE OR REPLACE PROCEDURE licenziamento_dipendente(numero_documento CHAR) AS  
BEGIN 
    -- Aggiorniamo la tabella "Dipendente" con il dato relativo alla data in cui è stato licenziato --
    UPDATE Dipendente SET data_di_licenziamento = SYSDATE WHERE Dipendente.fk_persona = numero_documento;  
END;