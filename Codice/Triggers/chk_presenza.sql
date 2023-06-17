--CHK PRESENZA--
CREATE OR REPLACE TRIGGER chk_presenza         
BEFORE UPDATE OF data_ora_uscita ON Presenza_dipendente       
FOR EACH ROW         
DECLARE
    -- EXCEPTION --
    -- Questa eccezione viene lanciata nel caso in cui il dipendente tenti di registrare un'uscita prima della fine del proprio turno --
    uscita_exc EXCEPTION;

	-- VARIABILI --
    ora_curr_timeX NUMBER := 0;
    ora_fine_turnoX NUMBER := 0;

BEGIN      
	-- Reperiamo l'informazione relativa alla ora di fine turno del dipendente --
    SELECT ora_fine_turno INTO ora_fine_turnoX FROM Tipologia_turno WHERE nome_tipologia_turno = :NEW.fk_tipologia_turno_nome;

	-- Salviamo in una variabile l'ora attuale --
    ora_curr_timeX := to_number(to_char(current_timestamp, 'HH24.MI'));

	-- Controlliamo se l'ora attuale risulta minore dell'orario di uscita del dipendente --
    IF(ora_curr_timeX < ora_fine_turnoX) THEN
        RAISE uscita_exc;
    END IF;

EXCEPTION         
    WHEN uscita_exc THEN   
        RAISE_APPLICATION_ERROR('-20117', 'USCITA NON CONSENTITA');
END;
