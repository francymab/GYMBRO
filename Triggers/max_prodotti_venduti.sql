--MAX PRODOTTI VENDUTI--
CREATE OR REPLACE TRIGGER max_prodotti_venduti     
BEFORE INSERT ON VENDITA     
FOR EACH ROW     
DECLARE     
    -- ECCEZIONI --
    -- Questa eccezione viene lanciata nel caso in cui vengano venduti più prodotti di quanti ne siano disponibili in giacenza --
    giacenza_exc EXCEPTION;

    -- VARIABILI --
    giacenzaX Prodotto.giacenza%type;
    
BEGIN  
    -- Reperiamo la giacenza dei prodotti --
    SELECT giacenza INTO giacenzaX FROM Prodotto WHERE codice_a_barre = :NEW.fk_prodotto;

    -- Controlliamo se la giacenza è minore della quantità che si vuole vendere --
    IF (giacenzaX < :NEW.quantita_venduta) THEN
        RAISE giacenza_exc;
     END IF;
   
EXCEPTION     
    WHEN giacenza_exc THEN 
            RAISE_APPLICATION_ERROR('-20109', 'LA GIACENZA DEL PRODOTTO ' || :NEW.fk_prodotto || ' È MINORE DELLA QUANTITA CHE SI VUOL VENDERE, GIACENZA: ' || giacenzaX);
END;
