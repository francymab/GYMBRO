--CHECK DATA SCHEDA--
CREATE OR REPLACE TRIGGER check_date_scheda     
BEFORE INSERT OR UPDATE OF data_fine_scheda ON scheda_di_allenamento     
FOR EACH ROW     
DECLARE     
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui la data dell'inizio della scheda di allenamento risultasse minore della data odierna --
    data_inizio_scheda_exc EXCEPTION;     
 	-- Questa eccezione viene lanciata nel caso in cui la data della fine della scheda di allenamento risultasse minore della scadenza minima --
    -- Ovvero, minore della (data inizio + 7), in questo si è deciso che una scheda deve durare almeno 7 giorni --
    data_fine_scheda_exc EXCEPTION;     
 	-- Questa eccezione viene lanciata nel caso in cui la data dell'inizio della scheda di allenamento risultasse maggiore della data della fine della scheda --
    data_inizio_maggiore_fine_exc EXCEPTION;   

	-- VARIABILI --
    data_scadenza_minima scheda_di_allenamento.data_fine_scheda%TYPE := :new.data_inizio_scheda + 7;     

BEGIN 
    -- Controlliamo se la data di inizio è maggiore della data di fine --
    IF ( :new.data_inizio_scheda > :new.data_fine_scheda ) THEN     
        RAISE data_inizio_maggiore_fine_exc;     
    END IF;     

	-- Controlliamo se la data di inizio è minore della data odierna --
    IF ( :new.data_inizio_scheda < trunc(sysdate) ) THEN     
        RAISE data_inizio_scheda_exc;     
    END IF;       

	-- Controlliamo se la data di fine è minore della scadenza minima (data inizio + 7) --
    IF ( :new.data_fine_scheda < data_scadenza_minima ) THEN     
    	RAISE data_fine_scheda_exc;     
    END IF;    
   
EXCEPTION     
    WHEN data_inizio_scheda_exc THEN     
        raise_application_error('-20100', '(SCHEDA_DI_ALLENAMENTO) ERRORE "data_inizio_scheda": '     
                                          || TO_DATE(:new.data_inizio_scheda, 'DD/MM/YYYY')     
                                          || ' < '     
                                          || sysdate);     
    WHEN data_fine_scheda_exc THEN     
        raise_application_error('-20101', '(SCHEDA_DI_ALLENAMENTO) ERRORE "data_fine_scheda": '     
                                          || TO_DATE(:new.data_fine_scheda, 'DD/MM/YYYY')     
                                          || ' < '     
                                          || TO_DATE(data_scadenza_minima, 'DD/MM/YYYY'));     
    WHEN data_inizio_maggiore_fine_exc THEN     
        raise_application_error('-20102', '(SCHEDA_DI_ALLENAMENTO) ERRORE "data_inizio_scheda" MAGGIORE "data_fine_scheda": '     
                                          || TO_DATE(:new.data_inizio_scheda, 'DD/MM/YYYY')     
                                          || ' > '     
                                          || TO_DATE(:new.data_fine_scheda, 'DD/MM/YYYY'));     
END;