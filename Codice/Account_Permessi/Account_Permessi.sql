--  CREAZIONE RUOLI E UTENTI

-- Creazione Amministratore e relativa assegnazione privilegi
CREATE USER Admin_Gymbro IDENTIFIED by oracle;

GRANT ALL PRIVILEGES TO Admin_Gymbro;

-- Creazione Ruoli
CREATE ROLE Responsabile_sede;
CREATE ROLE Segretaria;
CREATE ROLE Istruttore;
CREATE ROLE Utente;

-- Privilegi di sistema
GRANT CONNECT, CREATE SESSION TO Responsabile_sede;
GRANT CONNECT, CREATE SESSION TO Segretaria;
GRANT CONNECT, CREATE SESSION TO Istruttore;
GRANT CONNECT, CREATE SESSION TO Utente;

-- Privilegi di oggetto per Segretaria
GRANT SELECT, INSERT, UPDATE ON Persona TO Segretaria;
GRANT SELECT, INSERT, UPDATE ON Utente TO Segretaria;
GRANT SELECT, INSERT, UPDATE ON Prenotazione TO Segretaria;
GRANT SELECT, INSERT ON Vendita TO Segretaria;
GRANT SELECT, INSERT, UPDATE ON Sottoscrizione TO Segretaria;
GRANT SELECT ON Lezione_corso TO Segretaria;
GRANT SELECT ON Tipologia_abbonamento TO Segretaria;
GRANT SELECT ON Compreso TO Segretaria;
GRANT SELECT ON Corso TO Segretaria;
GRANT SELECT ON Assegnazione_settimanale TO Segretaria;
GRANT SELECT, INSERT ON Scontrino TO Segretaria;

GRANT SELECT ON VIEW_CORSI_SOTTOSCRITTI TO Segretaria;
GRANT SELECT ON VIEW_LEZIONI_SETTIMANALI TO Segretaria;
GRANT SELECT ON VIEW_SOTTOSCRIZIONI_ATTIVE TO Segretaria;
GRANT SELECT ON VIEW_SOTTOSCRIZIONI_ATTIVE TO Segretaria;
GRANT SELECT ON VIEW_SOTTOSCRIZIONI_SCADUTE TO Segretaria;

GRANT EXECUTE ON prenotazione_piscina TO Segretaria;
GRANT EXECUTE ON registra_turno TO Segretaria;
GRANT EXECUTE ON rinnovo_sottoscrizione TO Segretaria;
GRANT EXECUTE ON sottoscrizione_utente TO Segretaria;
GRANT EXECUTE ON vendita_prodotti TO Segretaria;

-- Privilegi di oggetto per Responsabile_sede
GRANT SELECT, INSERT, UPDATE ON Assegnazione_settimanale TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Dipendente TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Persona TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Esercizio TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Lezione_corso TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Piscina TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Presenza_dipendente TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Prodotto TO Responsabile_sede;
GRANT SELECT, INSERT, UPDATE ON Sala TO Responsabile_sede;
GRANT SELECT, INSERT ON Scontrino TO Responsabile_sede;
GRANT SELECT ON Tipologia_abbonamento TO Responsabile_sede;
GRANT SELECT ON Tipologia_turno TO Responsabile_sede;
GRANT SELECT ON Sede TO Responsabile_sede;
GRANT SELECT ON Utenza TO Responsabile_sede;
GRANT SELECT ON Compreso TO Responsabile_sede;
GRANT SELECT ON Corso TO Responsabile_sede;
GRANT SELECT ON Sottoscrizione TO Responsabile_sede;
GRANT SELECT ON Vendita TO Responsabile_sede;

GRANT SELECT ON VIEW_PRODOTTI_IN_ESAURIMENTO TO Responsabile_sede;
GRANT SELECT ON VIEW_LEZIONI_SETTIMANALI TO Responsabile_sede;
GRANT SELECT ON VIEW_RITARDI_EFFETTUATI TO Responsabile_sede;
GRANT SELECT ON VIEW_DIPENDENTI_NON_ASSEGNATI TO Responsabile_sede;
GRANT SELECT ON VIEW_CORSI_SOTTOSCRITTI TO Responsabile_sede;

GRANT EXECUTE ON assegna_dipendenti TO Responsabile_sede;
GRANT EXECUTE ON assunzione TO Responsabile_sede;
GRANT EXECUTE ON licenziamento_dipendente TO Responsabile_sede;

-- Privilegi di oggetto per Istruttore
GRANT SELECT, INSERT, UPDATE ON Scheda_di_allenamento TO Istruttore;
GRANT SELECT, INSERT, UPDATE ON Contiene TO Istruttore;
GRANT SELECT ON Lezione_corso TO Istruttore;
GRANT SELECT ON Assegnazione_settimanale TO Istruttore;
GRANT SELECT ON Esercizio TO Istruttore;

GRANT EXECUTE ON compila_scheda TO Istruttore;
GRANT EXECUTE ON registra_turno TO Istruttore;

-- Privilegi di oggetto per Utente
GRANT EXECUTE ON verifica_entrata TO Utente;

-- Creazione utenti e relativa assegnazione ruoli
CREATE USER seg1 IDENTIFIED BY Segretaria;
CREATE USER seg2 IDENTIFIED BY Segretaria;
CREATE USER seg3 IDENTIFIED BY Segretaria;
CREATE USER resp1 IDENTIFIED BY Responsabile_sede;
CREATE USER resp2 IDENTIFIED BY Responsabile_sede;
CREATE USER resp3 IDENTIFIED BY Responsabile_sede;
CREATE USER istr1 IDENTIFIED BY Istruttore;
CREATE USER istr2 IDENTIFIED BY Istruttore;
CREATE USER istr3 IDENTIFIED BY Istruttore;
CREATE USER ut1 IDENTIFIED BY Utente;
CREATE USER ut2 IDENTIFIED BY Utente;
CREATE USER ut3 IDENTIFIED BY Utente;

GRANT Responsabile_sede TO resp1, resp2, resp3;
GRANT Segretaria TO seg1, seg2, seg3;
GRANT Istruttore TO istr1, istr2, istr3;
GRANT Utente TO ut1, ut2, ut3;
