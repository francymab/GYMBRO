--VIEWS--
-- VISTA PER VISUALIZZARE TUTTE LE SOTTOSCRIZIONI ATTIVE --
CREATE OR REPLACE VIEW view_sottoscrizioni_attive AS
    SELECT
        id_sottoscrizione,
        numero_documento_persona,
        codice_fiscale_persona AS codice_fiscale,
        nome_persona           AS nome,
        cognome_persona        AS cognome,
        numero_tessera,
        fk_abbonamento_nome    AS tipologia_abbonamento,
        data_inizio_sottoscrizione,
        data_fine_sottoscrizione,
        certificato_medico
    FROM Sottoscrizione
        JOIN persona ON fk_utente = numero_documento_persona
                        AND ha_pagato = 'S'
                        AND data_fine_sottoscrizione > sysdate
        JOIN utente ON fk_persona = fk_utente
    ORDER BY
        id_sottoscrizione;

-- VISTA PER VISUALIZZARE TUTTE LE SOTTOSCRIZIONI SCADUTE --
CREATE OR REPLACE VIEW view_sottoscrizioni_scadute AS
    SELECT
        id_sottoscrizione,
        numero_documento_persona,
        codice_fiscale_persona AS codice_fiscale,
        nome_persona           AS nome,
        cognome_persona        AS cognome,
        numero_tessera,
        fk_abbonamento_nome    AS tipologia_abbonamento,
        data_inizio_sottoscrizione,
        data_fine_sottoscrizione,
        certificato_medico
    FROM Sottoscrizione
        JOIN persona ON fk_utente = numero_documento_persona
                        AND ha_pagato = 'N'
                        AND data_fine_sottoscrizione <= sysdate
        JOIN utente ON fk_persona = fk_utente
    ORDER BY
        id_sottoscrizione;
        
-- VISTA PER VISUALIZZARE TUTTE LE LEZIONI SETTIMANALI --
CREATE OR REPLACE VIEW view_lezioni_settimanali AS
    SELECT
        id_lezione,
        fk_sala_codice           AS codice_sala,
        fk_corso                 AS corso,
        nome_persona             AS nome_istruttore,
        cognome_persona          AS cognome_istruttore,
        giorno_settimana_lezione AS giorno,
        ora_inizio,
        ora_fine,
        fk_sala_via              AS via_sede,
        fk_sala_civico           AS civico_sede,
        fk_sala_cap              AS cap_sede
    FROM Dipendente
        JOIN persona ON fk_persona = numero_documento_persona
        JOIN lezione_corso ON fk_dipendente = fk_persona
    ORDER BY
        id_lezione;
        
-- VISTA PER VISUALIZZARE LO STORICO DELLE UTENZE PAGATE --
CREATE OR REPLACE VIEW view_storico_utenze_pagate AS
    SELECT
        numero_fattura,
        fk_sede_via    AS via_sede,
        fk_sede_civico AS civico_sede,
        fk_sede_cap    AS cap_sede,
        data_scadenza,
        tipologia_utenza,
        importo_utenza AS importo
    FROM
        utenza
    WHERE
        pagamento_utenza = 'S'
    ORDER BY
        data_scadenza;

-- VISTA UTILE A VISUALIZZARE IL GUADAGNO DAL MESE PRECEDENTE DALLE SOTTOSCRIZIONI A PARTIRE DALLA DATA ODIERNA --
CREATE OR REPLACE VIEW view_guadagno_mensile_sottoscrizioni AS
    SELECT
        SUM(costo_abbonamento) AS totale_guadagno,
        fk_sede_via            AS via_sede,
        fk_sede_civico         AS civico_sede,
        fk_sede_cap            AS cap_sede
    FROM Sottoscrizione
        JOIN tipologia_abbonamento ON fk_abbonamento_nome = nome_tipologia_abbonamento
    WHERE
        data_inizio_sottoscrizione >= add_months(sysdate, - 1)
    GROUP BY
        fk_sede_via,
        fk_sede_civico,
        fk_sede_cap;

-- VISTA UTILE A VISUALIZZARE IL GUADAGNO DAL MESE PRECEDENTE DALLE PRENOTAZIONI A PARTIRE DALLA DATA ODIERNA --
CREATE OR REPLACE VIEW view_guadagno_mensile_prenotazioni AS 
    SELECT 
        SUM(prezzo_prenotazione)    AS totale_guadagno, 
        fk_piscina_via              AS via_sede, 
        fk_piscina_civico           AS civico_sede, 
        fk_piscina_cap              AS cap_sede 
    FROM Prenotazione 
     
    WHERE 
        data_ora_prenotazione >= add_months(sysdate, - 1) 
    GROUP BY 
        fk_piscina_via, 
        fk_piscina_civico, 
        fk_piscina_cap

-- VISTA UTILE A VISUALIZZARE IL GUADAGNO DAL MESE PRECEDENTE DAGLI SCONTRINI A PARTIRE DALLA DATA ODIERNA --
CREATE OR REPLACE VIEW view_guadagno_mensile_scontrini AS  
    SELECT  
        SUM(prezzo_totale)       AS totale_guadagno,  
        fk_sede_via              AS via_sede,  
        fk_sede_civico           AS civico_sede,  
        fk_sede_cap              AS cap_sede  
    FROM Scontrino  
    WHERE  
        data_scontrino >= add_months(sysdate, - 1)  
    GROUP BY  
        fk_sede_via,  
        fk_sede_civico,  
        fk_sede_cap

-- VISTA UTILE A VISUALIZZARE I DIPENDENTI CHE DURANTE IL PROPRIO TURNO SONO ENTRATI IN RITARDO --
CREATE OR REPLACE VIEW view_ritardi_effettuati AS      
    SELECT      
	fk_dipendente					AS Dipendente, 
    	nome_persona					AS Nome, 
    	cognome_persona					AS Cognome, 
    	data_ora_entrata				AS Entrata_dipendente,      
    	fk_tipologia_turno_nome				AS Turno_assegnato,   
    	ora_inizio_turno            			AS Ora_turno_entrata, 
    	Presenza_dipendente.fk_sede_via			AS Via, 
        Presenza_dipendente.fk_sede_civico		AS Civico, 
        Presenza_dipendente.fk_sede_cap			AS Cap 
    	   
    FROM Presenza_dipendente      
    	JOIN Tipologia_turno ON fk_tipologia_turno_nome = nome_tipologia_turno  
    		JOIN Dipendente ON fk_dipendente = fk_persona 
    			JOIN Persona ON fk_persona = numero_documento_persona 
    WHERE      
    	to_number(to_char(data_ora_entrata, 'HH24.MI')) >= (ora_inizio_turno + 0.10)  


-- VISTA UTILE A VISUALIZZARE I PRODOTTI CHE SONO IN ESAURIMENTO --
CREATE OR REPLACE VIEW view_prodotti_in_esaurimento AS      
    SELECT      
	codice_a_barre,
    	nome_prodotto,
    	giacenza
    	   
    FROM Prodotto      
    WHERE      
    	giacenza < 10

-- VISTA UTILE A VISUALIZZARE QUANTE VOLTE UN CORSO È COMPRESO IN UNA SOTTOSCRIZIONE --
CREATE OR REPLACE VIEW view_corsi_sottoscritti AS  
	SELECT  
		count(fk_corso) 	AS TOT_SOTTOSCRIZIONI_CORSO,  
		fk_corso			AS CORSO  
	FROM  
		Sottoscrizione JOIN Tipologia_abbonamento ON Sottoscrizione.fk_abbonamento_nome = Tipologia_abbonamento.nome_tipologia_abbonamento  
			JOIN Compreso ON Tipologia_abbonamento.nome_tipologia_abbonamento = Compreso.fk_abbonamento_nome  
	GROUP BY  
		fk_corso  
	ORDER BY  
		TOT_SOTTOSCRIZIONI_CORSO DESC 


-- VISTA UTILE A VISUALIZZARE TUTTI I DIPENDENTI CHE NON SONO STATI ASSEGNATI NELLA SETTIMANA PROSSIMA --
CREATE OR REPLACE VIEW view_dipendenti_non_assegnati AS  
	SELECT DISTINCT 
		fk_dipendente							AS Numero_dipendente,   
    	nome_persona							AS Nome,   
    	cognome_persona							AS cognome  
      
	FROM  
		Assegnazione_settimanale   
    		JOIN Dipendente ON Assegnazione_settimanale.fk_dipendente = Dipendente.fk_persona  
    			JOIN Persona ON Dipendente.fk_persona = Persona.numero_documento_persona  
	WHERE  
		fk_dipendente NOT IN (SELECT fk_dipendente FROM Assegnazione_settimanale WHERE data_assegnazione BETWEEN TRUNC(SYSDATE + 7,'D') + 1 AND TRUNC(SYSDATE + 7,'D') + 6)
