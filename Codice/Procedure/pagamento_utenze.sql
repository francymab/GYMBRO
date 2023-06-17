--PAGAMENTO UTENZA--
CREATE OR REPLACE PROCEDURE pagamento_utenze(via_sede VARCHAR2, 
                                             civico_sede VARCHAR2, 
                                             cap_sede NUMBER) 
AS
    
BEGIN
    -- Aggiornamento di "pagamento_utenza" con il valore "S", per identificare che le utenze sono state pagate, di una specifica sede --
    UPDATE Utenza SET pagamento_utenza = 'S' 
        WHERE fk_sede_via = via_sede AND fk_sede_civico = civico_sede AND fk_sede_cap = cap_sede;
END;