--PAGAMENTO DELLA SOTTOSCRIZIONE--
CREATE OR REPLACE TRIGGER chk_sottoscrizione_pagata   
BEFORE UPDATE OF ha_pagato ON Sottoscrizione   
FOR EACH ROW   
BEGIN  
    -- In caso di rinnovo dell'iscrizione, cambiamo i valori della data nuova data inizio sottoscrizione --  
    -- alla data odierna e la nuova data fine sottoscrizione 
    IF(:NEW.ha_pagato = 'S' AND :OLD.ha_pagato = 'N') THEN 
        :NEW.data_inizio_sottoscrizione := SYSDATE;   
        :NEW.data_fine_sottoscrizione := add_months(SYSDATE, :NEW.fk_abbonamento_durata);   
 	END IF; 
END;
