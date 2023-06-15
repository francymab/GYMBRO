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
        
-- VISTA PER VISUALIZZARE IL GUADAGNO MENSILE OTTENUTO DALLE SOTTOSCRIZIONI --
CREATE OR REPLACE VIEW view_guadagno_mensile AS
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
        
