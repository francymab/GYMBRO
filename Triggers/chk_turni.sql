--COONTROLLO ASSEGNAZIONE TURNI SOVRAPPOSTI--
CREATE OR REPLACE TRIGGER chk_turni 
BEFORE INSERT ON Assegnazione_settimanale 
FOR EACH ROW 
DECLARE
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui si vuole assegnare il dipendente ad un turno --
    -- in cui gli orari sono compresi in un turno a cui è stato già assegnato --
	turno_exc EXCEPTION; 

    -- VARIABILI --
    ora_inizio_turnoX NUMBER; 
    ora_fine_turnoX NUMBER; 
    count_dipendente NUMBER := 0; 

BEGIN 
    -- Ricaviamo le informazioni relativi all'ora inizio turno e ora fine turno --
    SELECT ora_inizio_turno, ora_fine_turno INTO ora_inizio_turnoX, ora_fine_turnoX FROM Tipologia_turno WHERE nome_tipologia_turno = :NEW.fk_tipologia_turno_nome; 

    -- Contiamo se il dipendente è stato già assegnato per quella data e per quella fascia oraria --
    SELECT count(fk_dipendente) INTO count_dipendente FROM Assegnazione_settimanale JOIN Tipologia_turno ON fk_tipologia_turno_nome = nome_tipologia_turno 
        WHERE data_assegnazione = :NEW.data_assegnazione AND fk_dipendente = :NEW.fk_dipendente AND (ora_inizio_turnoX BETWEEN ora_inizio_turno AND ora_fine_turno 
            OR ora_fine_turnoX BETWEEN ora_inizio_turno AND ora_fine_turno); 

    -- Se il count è maggiore di 0 significa che l'utente ha già un'assegnazione disponibile per quella fascia oraria --
    IF(count_dipendente > 0) THEN 
        RAISE turno_exc; 
    END IF; 
 
EXCEPTION 
    WHEN turno_exc THEN 
    	RAISE_APPLICATION_ERROR('-20118', 'IL DIPENDENTE È GIÀ STATO ASSEGNATO PER QUESTE ORE'); 
END;
