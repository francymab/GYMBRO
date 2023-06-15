--REGISTRA TURNO--
CREATE OR REPLACE PROCEDURE registra_turno(numero_dipendente VARCHAR2) 
AS
        -- ECCEZIONI --
   	-- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO" --     
	sede_exc EXCEPTION;
	-- Questa eccezione viene lanciata nel caso in cui il dipendente che vuole effettuare la presenza risulta lincenziato
	licenziato_exc EXCEPTION;

	-- CURSORI --
	-- Questo cursore seleziona tutte le assegnazione della data odierna del dipendente e le relative informazioni associate ottenute dalla tabella "Tipologia_turno" --
	CURSOR C IS (select *
                 from Assegnazione_settimanale join Tipologia_turno 
                 on fk_tipologia_turno_nome = nome_tipologia_turno
                 where fk_dipendente = numero_dipendente and data_assegnazione = to_date(sysdate, 'DD-MM-YY'));

	-- VARIABILI --
	stato_sedeX Sede.stato_sede%TYPE;
	ora_inizio_turnoX NUMBER := to_number(to_char(current_timestamp, 'HH24.MI'));
        dip Dipendente%rowtype;
    	count_presenze_dipendente NUMBER;

BEGIN
        -- Prendiamo le informazioni relativi al dipendente --
        SELECT * INTO dip FROM Dipendente WHERE fk_persona = numero_dipendente;

        -- Controlliamo che l'utente non sia stato licenziato in precedenza --
        IF (dip.data_di_licenziamento IS NOT NULL) THEN
            RAISE licenziato_exc;
        END IF;
        
        -- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" -- 
        SELECT stato_sede INTO stato_sedeX FROM Sede    
            WHERE via_sede = dip.fk_sede_via AND civico_sede = dip.fk_sede_civico AND cap_sede = dip.fk_sede_cap;   

        IF (stato_sedeX = 'NON ATTIVO') THEN   
            RAISE sede_exc;   
        END IF;

	-- Viene effettuato un ciclo per ogni assegnazione del dipendente nella data odierna --
	-- Si conta, prima di tutto, quante presenze ha effettuato il dipendente, tenendo conto della data 
        -- odierna, del turno a lui assegnato e della data di uscita --
        -- Se il count risultasse 0, vuol dire che non esiste una presenza in entrata effettuata dal dipendente --
	-- nella data odierna durante il suo turno. Per cui, controlliamo se "ora_inizio_turnoX", che rappresenta --
        -- l'orario in cui entra il dipendente, sia compreso tra l'inizio e la fine del suo turno. Se risultasse vero --
        -- allora inseriamo la presenza del dipendente --
        -- Se il count risultasse 1, vuol dire che esiste una presenza del dipendente nella data odierna durante il suo turno --
        -- In questo caso, deduciamo che il dipendente voglia registrare la sua uscita --
        FOR turno_dip IN C LOOP
            SELECT count(fk_dipendente) INTO count_presenze_dipendente FROM Presenza_dipendente 
                WHERE fk_dipendente = numero_dipendente 
                AND trunc(data_ora_entrata)= to_date(sysdate, 'DD-MM-YY') 
                AND UPPER(fk_tipologia_turno_nome) = UPPER(turno_dip.fk_tipologia_turno_nome) 
                AND data_ora_uscita IS NULL AND fk_sede_via = dip.fk_sede_via 
                AND fk_sede_civico = dip.fk_sede_civico AND fk_sede_cap = dip.fk_sede_cap;

            IF(ora_inizio_turnoX BETWEEN turno_dip.ora_inizio_turno AND turno_dip.ora_fine_turno AND count_presenze_dipendente = 0) THEN
                INSERT INTO Presenza_dipendente(data_ora_entrata, 
                                                fk_dipendente, 
                                                fk_sede_via, 
                                                fk_sede_civico, 
                                                fk_sede_cap,  
                                                fk_tipologia_turno_nome) 
                    VALUES (current_timestamp, 
                            numero_dipendente, 
                            dip.fk_sede_via,
                            dip.fk_sede_civico,
                            dip.fk_sede_cap,  
                            turno_dip.fk_tipologia_turno_nome); 
            END IF;

            IF(count_presenze_dipendente = 1) THEN
                UPDATE Presenza_dipendente SET data_ora_uscita = current_timestamp 
                    WHERE fk_dipendente = numero_dipendente 
                    AND UPPER(fk_tipologia_turno_nome) = UPPER(turno_dip.fk_tipologia_turno_nome) 
                    AND data_ora_uscita IS NULL;
            END IF;
        END LOOP;

	EXCEPTION
        WHEN sede_exc THEN   
            RAISE_APPLICATION_ERROR('-20008', 'LA SEDE ' || dip.fk_sede_via || ', '|| dip.fk_sede_civico || ', '|| dip.fk_sede_cap || ' NON È ATTIVA');
        WHEN licenziato_exc THEN   
            RAISE_APPLICATION_ERROR('-20009', 'IL DIPENDENTE È STATO LICENZIATO!');
END;