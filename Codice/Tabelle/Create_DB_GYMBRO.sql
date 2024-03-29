-----CREAZIONE TABELLE-----

-----PERSONA-----
CREATE TABLE Persona (  
    -- ATTRIBUTI --  
    numero_documento_persona CHAR(9) PRIMARY KEY,   
    nome_persona             VARCHAR2(15),   
    cognome_persona          VARCHAR2(15),   
    genere_persona           CHAR(1) CHECK ( UPPER(genere_persona) = 'M'   
                                   OR UPPER(genere_persona) = 'F' ),   
    codice_fiscale_persona   CHAR(16) UNIQUE NOT NULL,   
    data_di_nascita          DATE NOT NULL, 		   
    eta_persona              NUMBER(2, 0),   
    via_persona              VARCHAR2(30),   
    civico_persona           VARCHAR2(5),   
    cap_persona              NUMBER(5, 0),   
    telefono_persona         CHAR(10)  
);

-----SEDE-----
CREATE TABLE Sede (    
    -- ATTRIBUTI -- 
    via_sede          VARCHAR2(30),
    civico_sede       VARCHAR2(5),
    cap_sede          NUMBER(5, 0),
    metri_quadri_sede NUMBER(4, 0) CHECK ( metri_quadri_sede > 0 ),
    telefono_sede     VARCHAR2(10),
    stato_sede        VARCHAR(12) DEFAULT 'ATTIVO' CHECK ( UPPER(stato_sede) = 'ATTIVO'
                                                    OR UPPER(stato_sede) = 'NON ATTIVO' ),  
        
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_sede PRIMARY KEY ( via_sede, civico_sede, cap_sede )
);

-----ESERCIZIO-----
CREATE TABLE Esercizio (   
    -- ATTRIBUTI -- 
    nome_esercizio        VARCHAR2(35) PRIMARY KEY,   
    nome_gruppo_muscolare VARCHAR2(35)   
);

-----TIPOLOGIA TURNO-----
CREATE TABLE Tipologia_turno (   
    -- ATTRIBUTI -- 
    nome_tipologia_turno   VARCHAR2(15) PRIMARY KEY,
    ora_inizio_turno	   NUMBER(4,2) NOT NULL,
    ora_fine_turno	   NUMBER(4,2) NOT NULL
);

-----PRODOTTO-----
CREATE TABLE Prodotto (   
    -- ATTRIBUTI --  
    codice_a_barre          CHAR(13) PRIMARY KEY,
    nome_prodotto           VARCHAR2(50),
    prezzo_vendita_unitario NUMBER(7, 2) NOT NULL,
    giacenza                NUMBER(4, 0) NOT NULL
);

-----CORSO-----
CREATE TABLE Corso(   
    -- ATTRIBUTI --  
    nome_corso VARCHAR2(30) PRIMARY KEY,   
    obiettivo  VARCHAR2(20)   
);

-----TIPOLOGIA ABBONAMENTO-----
CREATE TABLE Tipologia_abbonamento (  
    -- ATTRIBUTI -- 
    nome_tipologia_abbonamento VARCHAR2(100),
    durata_abbonamento         NUMBER(2, 0) CHECK ( durata_abbonamento BETWEEN 1 AND 12 ),
    costo_abbonamento          NUMBER(5, 2) CHECK ( costo_abbonamento > 0 ) NOT NULL,    
    
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_tipologia_abbonamento PRIMARY KEY ( nome_tipologia_abbonamento,
                                                      durata_abbonamento )
);

-----DIPENDENTE-----
CREATE TABLE Dipendente (   
    -- ATTRIBUTI -- 
    fk_persona            CHAR(9) PRIMARY KEY,
    codice_iban           CHAR(27) NOT NULL UNIQUE,
    mansione              VARCHAR(30) NOT NULL,
    stipendio_mensile     NUMBER(6, 2) DEFAULT 1000.00 CHECK ( stipendio_mensile BETWEEN 800.00 AND 5000.00 ),
    titolo_di_studio      VARCHAR2(40),
    data_di_licenziamento DATE DEFAULT NULL,
    fk_sede_via           VARCHAR2(30),
    fk_sede_civico        VARCHAR2(5),
    fk_sede_cap           NUMBER(5, 0),   
   
    -- VINCOLI DI CHIAVE ESTERNA -- 
    CONSTRAINT fk_persona_dipendente FOREIGN KEY ( fk_persona )
        REFERENCES Persona ( numero_documento_persona )
        ON DELETE CASCADE,
    CONSTRAINT fk_sede_dipendente FOREIGN KEY ( fk_sede_via,
                                                fk_sede_civico,
                                                fk_sede_cap )
        REFERENCES Sede ( via_sede,
                          civico_sede,
                          cap_sede )
);

-----UTENTE-----
CREATE TABLE Utente (  
    -- ATTRIBUTI -- 
    fk_persona     CHAR(9) PRIMARY KEY,
    numero_tessera CHAR(8) UNIQUE,  
  
    -- VINCOLI DI CHIAVE ESTERNA -- 
    CONSTRAINT fk_utente_persona FOREIGN KEY ( fk_persona )
        REFERENCES Persona ( numero_documento_persona )
        ON DELETE CASCADE
);

-----UTENZA-----
CREATE TABLE Utenza (   
    -- ATTRIBUTI -- 
    numero_fattura   VARCHAR2(10) PRIMARY KEY,
    fk_sede_via      VARCHAR2(30),
    fk_sede_civico   VARCHAR2(5),
    fk_sede_cap      NUMBER(5, 0),
    importo_utenza   NUMBER(8, 2) CHECK ( importo_utenza > 0 ) NOT NULL,
    pagamento_utenza CHAR(1) DEFAULT 'N' CHECK ( UPPER(pagamento_utenza) = 'S'
                                                 OR UPPER(pagamento_utenza) = 'N' ),
    data_scadenza    DATE NOT NULL,
    tipologia_utenza VARCHAR2(30),   
   
    -- VINCOLI DI CHIAVE ESTERNA -- 
    CONSTRAINT fk_sede_utenza FOREIGN KEY ( fk_sede_via,
                                            fk_sede_civico,
                                            fk_sede_cap )
        REFERENCES Sede ( via_sede,
                          civico_sede,
                          cap_sede )
);

-----PRESENZA DIPENDENTE-----
CREATE TABLE Presenza_dipendente (   
    -- ATTRIBUTI --   
    data_ora_entrata            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_ora_uscita             TIMESTAMP,
    fk_dipendente             CHAR(9),
    fk_sede_via               VARCHAR2(30) NOT NULL,
    fk_sede_civico            VARCHAR2(5) NOT NULL,
    fk_sede_cap               NUMBER(5, 0) NOT NULL,
    fk_tipologia_turno_nome   VARCHAR2(15) NOT NULL,
   
    -- VINCOLI DI CHIAVE PRIMARIA --   
    CONSTRAINT pk_presenza_dipendente PRIMARY KEY (data_ora_entrata,
                                                   fk_dipendente ),   
   
    -- VINCOLI DI CHIAVE ESTERNA --   
    CONSTRAINT fk_presenza_dipendente FOREIGN KEY ( fk_dipendente )
        REFERENCES Dipendente ( fk_persona ), -- on delete default --   

    CONSTRAINT fk_sede_presenza FOREIGN KEY ( fk_sede_via,
                                              fk_sede_civico,
                                              fk_sede_cap )
        REFERENCES Sede ( via_sede,
                          civico_sede,
                          cap_sede ),  -- on delete default --   

    CONSTRAINT fk_tipologia_turno_presenza FOREIGN KEY ( fk_tipologia_turno_nome)
        REFERENCES Tipologia_turno ( nome_tipologia_turno ) -- on delete default --   
);

-----SCHEDA DI ALLENAMENTO-----
CREATE TABLE Scheda_di_allenamento (  
    -- ATTRIBUTI --  
    data_inizio_scheda DATE,
    fk_utente          CHAR(9),
    fk_dipendente      CHAR(9) NOT NULL,
    data_fine_scheda   DATE,  
  
    -- VINCOLI DI CHIAVE PRIMARIA --   
    CONSTRAINT pk_scheda_di_allenamento PRIMARY KEY ( data_inizio_scheda,
                                                      fk_utente ),  
  
    -- VINCOLI DI CHIAVE ESTERNA --   
    CONSTRAINT fk_dipendente_scheda FOREIGN KEY ( fk_dipendente )
        REFERENCES Dipendente ( fk_persona ), -- on delete default --  

    CONSTRAINT fk_utente_scheda FOREIGN KEY ( fk_utente )
        REFERENCES Utente ( fk_persona ) -- on delete default --  
);

-----SCONTRINO-----
CREATE TABLE Scontrino(  
    -- ATTRIBUTI --  
    id_scontrino NUMBER(6,0) PRIMARY KEY,  
    fk_sede_via VARCHAR2(30) NOT NULL,  
    fk_sede_civico VARCHAR2(5) NOT NULL,  
    fk_sede_cap NUMBER(5,0) NOT NULL,  
    data_scontrino TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    prezzo_totale NUMBER(7,2) CHECK (prezzo_totale > 0),  
      
    -- VINCOLI DI CHIAVE ESTERNA --   
    CONSTRAINT fk_sede_scontrino FOREIGN KEY(fk_sede_via, fk_sede_civico, fk_sede_cap)  
    	REFERENCES Sede(via_sede, civico_sede, cap_sede) -- on delete default --  
);

-----PISCINA-----
CREATE TABLE Piscina (  
    -- ATTRIBUTI --  
    numero_piscina NUMBER(1, 0),
    fk_sede_via    VARCHAR2(30),
    fk_sede_civico VARCHAR2(5),
    fk_sede_cap    NUMBER(5, 0),
    larghezza      NUMBER(3, 1) DEFAULT 25.0 CHECK ( larghezza > 0 ),
    lunghezza      NUMBER(3, 1) DEFAULT 50.0 CHECK ( lunghezza > 0 ),
    profondita     NUMBER(3, 1) DEFAULT 2.0 CHECK ( profondita > 0 ),
    capienza       NUMBER(3, 0) CHECK ( capienza > 0 ) NOT NULL,
    numero_corsie  NUMBER(2, 0) DEFAULT 5 CHECK ( numero_corsie BETWEEN 2 AND 10 ),  
  
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_piscina PRIMARY KEY ( numero_piscina,
                                        fk_sede_via,
                                        fk_sede_civico,
                                        fk_sede_cap ),  
      
    -- VINCOLI DI CHIAVE ESTERNA --   
    CONSTRAINT fk_sede_piscina FOREIGN KEY ( fk_sede_via,
                                             fk_sede_civico,
                                             fk_sede_cap )
        REFERENCES Sede ( via_sede,
                          civico_sede,
                          cap_sede ) -- on delete default --  
);

-----SALA-----
CREATE TABLE Sala (  
    -- ATTRIBUTI --  
    codice_sala       VARCHAR2(5),
    fk_sede_via       VARCHAR2(30),
    fk_sede_civico    VARCHAR2(5),
    fk_sede_cap       NUMBER(5, 0),
    metri_quadri_sala NUMBER(2, 0) CHECK ( metri_quadri_sala > 0 ),
    tipologia_sala    VARCHAR2(20) NOT NULL,  
      
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_sala PRIMARY KEY ( codice_sala,
                                     fk_sede_via,
                                     fk_sede_civico,
                                     fk_sede_cap ),  
      
    -- VINCOLI DI CHIAVE ESTERNA --   
    CONSTRAINT fk_sede_sala FOREIGN KEY ( fk_sede_via,
                                          fk_sede_civico,
                                          fk_sede_cap )
        REFERENCES Sede ( via_sede,
                          civico_sede,
                          cap_sede ) -- on delete default --  
);

-----LEZIONE CORSO-----
CREATE TABLE lezione_corso (  
    -- ATTRIBUTI --  
    id_lezione               NUMBER(5, 0) PRIMARY KEY,
    fk_sala_codice           VARCHAR2(5) NOT NULL,
    fk_sala_via              VARCHAR2(30) NOT NULL,
    fk_sala_civico           VARCHAR2(5) NOT NULL,
    fk_sala_cap              NUMBER(5, 0) NOT NULL,
    fk_corso                 VARCHAR2(30) NOT NULL,
    fk_dipendente            CHAR(9) NOT NULL,
    giorno_settimana_lezione CHAR(3) CHECK ( upper(giorno_settimana_lezione) 
                                             IN ( 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT' ) ) NOT NULL,
    ora_inizio               NUMBER(4, 2) NOT NULL,
    ora_fine                 NUMBER(4, 2) NOT NULL,  
      
    -- VINCOLI DI CHIAVE ESTERNA --  
    CONSTRAINT fk_sala_lezione FOREIGN KEY ( fk_sala_via,
                                             fk_sala_civico,
                                             fk_sala_cap,
                                             fk_sala_codice )
        REFERENCES sala ( fk_sede_via,
                          fk_sede_civico,
                          fk_sede_cap,
                          codice_sala )
        ON DELETE CASCADE,
    CONSTRAINT fk_corso_lezione FOREIGN KEY ( fk_corso )
        REFERENCES corso ( nome_corso )
            ON DELETE CASCADE,
    CONSTRAINT fk_istruttore_lezione FOREIGN KEY ( fk_dipendente )
        REFERENCES dipendente ( fk_persona ) -- on delete default --  
);

-----SOTTOSCRIZIONE-----
CREATE TABLE Sottoscrizione (  
    -- ATTRIBUTI --  
    id_sottoscrizione          NUMBER(6, 0) PRIMARY KEY,
    fk_utente                  CHAR(9) NOT NULL,
    fk_abbonamento_nome        VARCHAR2(100) NOT NULL,
    fk_abbonamento_durata      NUMBER(2, 0) NOT NULL,
    fk_sede_via                VARCHAR2(30) NOT NULL,
    fk_sede_civico             VARCHAR2(5) NOT NULL,
    fk_sede_cap                NUMBER(5, 0) NOT NULL,
    data_inizio_sottoscrizione DATE DEFAULT current_date NOT NULL,
    data_fine_sottoscrizione   DATE,
    ha_pagato                  CHAR(1) DEFAULT 'S' CHECK ( UPPER(ha_pagato) = 'S'
                                                        OR UPPER(ha_pagato) = 'N' ),
    certificato_medico         CHAR(1) DEFAULT 'S' CHECK ( UPPER(certificato_medico) = 'S'
                                                        OR UPPER(certificato_medico) = 'N' ),  
  
    -- VINCOLI DI CHIAVE ESTERNA --  
    CONSTRAINT fk_utente_sottoscrizione FOREIGN KEY ( fk_utente )
        REFERENCES Utente ( fk_persona ),  -- on delete default -- 

    CONSTRAINT fk_sede_sottoscrizione FOREIGN KEY ( fk_sede_via,
                                                    fk_sede_civico,
                                                    fk_sede_cap )
        REFERENCES Sede ( via_sede,
                          civico_sede,
                          cap_sede ), -- on delete default --  

    CONSTRAINT fk_abbonamento_sottoscrizione FOREIGN KEY ( fk_abbonamento_nome,
                                                           fk_abbonamento_durata )
        REFERENCES Tipologia_abbonamento ( nome_tipologia_abbonamento,
                                           durata_abbonamento )
);

-----ASSEGNAZIONE SETTIMANALE-----
CREATE TABLE Assegnazione_settimanale ( 
    -- ATTRIBUTI -- 
    data_assegnazione         DATE,
    fk_dipendente             CHAR(9),
    fk_tipologia_turno_nome   VARCHAR2(15),
 
    -- VINCOLI DI CHIAVE PRIMARIA -- 
    CONSTRAINT pk_assegnazione_settimanale PRIMARY KEY ( data_assegnazione,
                                                         fk_dipendente,
                                                         fk_tipologia_turno_nome ), 
     
    -- VINCOLI DI CHIAVE ESTERNA -- 
    CONSTRAINT fk_dipendente_assegnazione FOREIGN KEY ( fk_dipendente )
        REFERENCES Dipendente ( fk_persona ), -- on delete default -- 

    CONSTRAINT fk_turno_assegnazione FOREIGN KEY ( fk_tipologia_turno_nome )
        REFERENCES Tipologia_turno ( nome_tipologia_turno )
);

-----CONTIENE-----
CREATE TABLE Contiene ( 
    -- ATTRIBUTI -- 
    numero_serie        NUMBER(2, 0),
    fk_scheda_data      DATE,
    fk_scheda_utente    CHAR(9),
    fk_esercizio        VARCHAR2(35),
    peso                NUMBER(3, 0) CHECK ( peso >= 0 ),
    numero_ripetizioni  NUMBER(3, 0) CHECK ( numero_ripetizioni >= 0 ),
    secondi_di_recupero NUMBER(3, 0) CHECK ( secondi_di_recupero >= 0 ) NOT NULL, 
 
    -- VINCOLI DI CHIAVE PRIMARIA -- 
    CONSTRAINT pk_contiene PRIMARY KEY ( numero_serie,
                                         fk_scheda_data,
                                         fk_scheda_utente,
                                         fk_esercizio ), 
     
    -- VINCOLI DI CHIAVE ESTERNA -- 
    CONSTRAINT fk_scheda_contiene FOREIGN KEY ( fk_scheda_data,
                                                fk_scheda_utente )
        REFERENCES Scheda_di_allenamento ( data_inizio_scheda,
                                           fk_utente )
        ON DELETE CASCADE,
    CONSTRAINT fk_esercizio_contiene FOREIGN KEY ( fk_esercizio )
        REFERENCES Esercizio ( nome_esercizio )
        ON DELETE CASCADE
);

-----VENDITA-----
CREATE TABLE Vendita (  
    -- ATTRIBUTI --  
    fk_scontrino     NUMBER(6, 0),
    fk_prodotto      CHAR(13),
    quantita_venduta NUMBER(3, 0) CHECK ( quantita_venduta > 0) NOT NULL,  
  
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_vendita PRIMARY KEY ( fk_scontrino,
                                        fk_prodotto ),   
      
    -- VINCOLI DI CHIAVE ESTERNA --  
    CONSTRAINT fk_scontrino_vendita FOREIGN KEY ( fk_scontrino )
        REFERENCES Scontrino ( id_scontrino ), -- on delete default --  

    CONSTRAINT fk_prodotto_vendita FOREIGN KEY ( fk_prodotto )
        REFERENCES Prodotto ( codice_a_barre )
);

-----PRENOTAZIONE-----
CREATE TABLE Prenotazione (  
    -- ATTRIBUTI --  
    data_ora_prenotazione   TIMESTAMP,
    fk_utente           CHAR(9),
    fk_piscina_numero   NUMBER(1,0),
    fk_piscina_via      VARCHAR2(30),
    fk_piscina_civico   VARCHAR2(5),
    fk_piscina_cap      NUMBER(5, 0),
    prezzo_prenotazione NUMBER(5, 2) CHECK ( prezzo_prenotazione > 0 ) NOT NULL,    
  
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_prenotazione PRIMARY KEY ( data_ora_prenotazione,
                                             fk_utente,
                                             fk_piscina_numero,
                                             fk_piscina_via,
                                             fk_piscina_civico,
                                             fk_piscina_cap ),  
      
    -- VINCOLI DI CHIAVE ESTERNA --  
    CONSTRAINT fk_piscina_prenotazione FOREIGN KEY ( fk_piscina_numero,
                                                     fk_piscina_via,
                                                     fk_piscina_civico,
                                                     fk_piscina_cap )
        REFERENCES Piscina ( numero_piscina,
                             fk_sede_via,
                             fk_sede_civico,
                             fk_sede_cap )
        ON DELETE CASCADE,
    CONSTRAINT fk_utente_prenotazione FOREIGN KEY ( fk_utente )
        REFERENCES Utente ( fk_persona ) -- on delete default --  
);

-----COMPRESO-----
CREATE TABLE Compreso(  
    -- ATTRIBUTI --    
    fk_corso VARCHAR2(30),  
    fk_abbonamento_nome VARCHAR2(100),  
    fk_abbonamento_durata NUMBER(2,0),  
    	  
    -- VINCOLI DI CHIAVE PRIMARIA --  
    CONSTRAINT pk_compreso PRIMARY KEY(fk_corso, fk_abbonamento_nome, fk_abbonamento_durata),  
      
    -- VINCOLI DI CHIAVE ESTERNA --  
    CONSTRAINT fk_corso_compreso FOREIGN KEY(fk_corso)   
    	REFERENCES Corso(nome_corso) ON DELETE CASCADE,  
      
    CONSTRAINT fk_tipologia_abbonamento_compreso FOREIGN KEY(fk_abbonamento_nome, fk_abbonamento_durata)  
    	REFERENCES Tipologia_abbonamento(nome_tipologia_abbonamento, durata_abbonamento) ON DELETE CASCADE  
);
