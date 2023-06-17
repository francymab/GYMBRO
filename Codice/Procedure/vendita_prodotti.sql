--VENDITA PRODOTTI--
create or replace PROCEDURE vendita_prodotti(sede_via VARCHAR2,
                                             sede_civico VARCHAR2,
                                             sede_cap VARCHAR2,
                                             codice_a_barre1 CHAR,
                                             quantita_venduta1 NUMBER,
                                             codice_a_barre2 CHAR := NULL,
                                             quantita_venduta2 NUMBER := NULL,
                                             codice_a_barre3 CHAR := NULL,
                                             quantita_venduta3 NUMBER := NULL,
                                             codice_a_barre4 CHAR := NULL,
                                             quantita_venduta4 NUMBER := NULL,
                                             codice_a_barre5 CHAR := NULL,
                                             quantita_venduta5 NUMBER := NULL)
    AS
    	-- ECCEZIONI --
	-- Questa eccezione viene lanciata nel caso in cui la sede inserita si trova nello stato "NON ATTIVO"
        sede_exc EXCEPTION;

	-- Variabili --
        prezzo_vendita_un Prodotto.prezzo_vendita_unitario%type;
        prezzo_totX Scontrino.prezzo_totale%type := 0;
        stato_sedeX Sede.stato_sede%type;

    BEGIN
        -- Controlliamo se la sede è nello stato "ATTIVO" o "NON ATTIVO" --
        SELECT stato_sede INTO stato_sedeX FROM Sede 
            WHERE via_sede = sede_via AND civico_sede = sede_civico AND cap_sede = sede_cap;

        IF (stato_sedeX = 'NON ATTIVO') THEN
            RAISE sede_exc;
        END IF;

        -- Reperiamo il prezzo di vendita unitario del primo prodotto selezionato dalla tabella "Prodotto" --
        SELECT prezzo_vendita_unitario INTO prezzo_vendita_un 
            FROM Prodotto where codice_a_barre = codice_a_barre1;

        -- Calcolo del totale dello scontrino --
        prezzo_totX := prezzo_totX + (prezzo_vendita_un * quantita_venduta1);

	-- Controlliamo se è stato inserito un ulteriore prodotto da vendere --
        IF (codice_a_barre2 IS NOT NULL AND quantita_venduta2 IS NOT NULL) THEN
        	-- Reperiamo il prezzo di vendita unitario del primo prodotto selezionato dalla tabella "Prodotto" --
            SELECT prezzo_vendita_unitario INTO prezzo_vendita_un 
                FROM Prodotto where codice_a_barre = codice_a_barre2;

        	-- Calcolo del totale dello scontrino --
            prezzo_totX := prezzo_totX + (prezzo_vendita_un * quantita_venduta2);
        END IF;

	-- Controlliamo se è stato inserito un ulteriore prodotto da vendere -- 
        IF (codice_a_barre3 IS NOT NULL AND quantita_venduta3 IS NOT NULL) THEN
        	-- Reperiamo il prezzo di vendita unitario del primo prodotto selezionato dalla tabella "Prodotto" --
            SELECT prezzo_vendita_unitario INTO prezzo_vendita_un 
                FROM Prodotto where codice_a_barre = codice_a_barre3;

        	-- Calcolo del totale dello scontrino --
            prezzo_totX := prezzo_totX + (prezzo_vendita_un * quantita_venduta3);
        END IF;

	-- Controlliamo se è stato inserito un ulteriore prodotto da vendere -- 
        IF (codice_a_barre4 IS NOT NULL AND quantita_venduta4 IS NOT NULL) THEN
        	-- Reperiamo il prezzo di vendita unitario del primo prodotto selezionato dalla tabella "Prodotto" --
            SELECT prezzo_vendita_unitario INTO prezzo_vendita_un 
                FROM Prodotto where codice_a_barre = codice_a_barre4;

        	-- Calcolo del totale dello scontrino --
            prezzo_totX := prezzo_totX + (prezzo_vendita_un * quantita_venduta4);
        END IF;

	-- Controlliamo se è stato inserito un ulteriore prodotto da vendere -- 
        IF (codice_a_barre5 IS NOT NULL AND quantita_venduta5 IS NOT NULL) THEN
        	-- Reperiamo il prezzo di vendita unitario del primo prodotto selezionato dalla tabella "Prodotto" --
            SELECT prezzo_vendita_unitario INTO prezzo_vendita_un 
                FROM Prodotto where codice_a_barre = codice_a_barre5;

        	-- Calcolo del totale dello scontrino --
            prezzo_totX := prezzo_totX + (prezzo_vendita_un * quantita_venduta5);
        END IF;

        -- Creazione dello scontrino --
        INSERT INTO Scontrino (fk_sede_via, fk_sede_civico, fk_sede_cap, prezzo_totale)
            VALUES (sede_via, sede_civico, sede_cap, prezzo_totX);

        -- Inseriamo i dati relativi alla vendita del/dei prodotto/i, associando lo scontrino, il/i prodotto/i e la quantità venduta --
        INSERT INTO Vendita VALUES(id_scontrino_seq.currval, codice_a_barre1, quantita_venduta1);

        IF (codice_a_barre2 IS NOT NULL) THEN
            INSERT INTO Vendita VALUES(id_scontrino_seq.currval, codice_a_barre2, quantita_venduta2);
        END IF;

        IF (codice_a_barre3 IS NOT NULL) THEN
            INSERT INTO Vendita VALUES(id_scontrino_seq.currval, codice_a_barre3, quantita_venduta3);
        END IF;

        IF (codice_a_barre4 IS NOT NULL) THEN
            INSERT INTO Vendita VALUES(id_scontrino_seq.currval, codice_a_barre4, quantita_venduta4);
        END IF;

        IF (codice_a_barre5 IS NOT NULL) THEN
            INSERT INTO Vendita VALUES(id_scontrino_seq.currval, codice_a_barre5, quantita_venduta5);
        END IF;

    EXCEPTION
        WHEN sede_exc THEN
            RAISE_APPLICATION_ERROR('-20002', 'LA SEDE ' || sede_via || ', '|| sede_civico || ', '|| sede_cap || ' NON È ATTIVA');
    END;