--GENERA UTENZE--
create or replace PROCEDURE genera_utenza
AS  
    importo Utenza.importo_utenza%type;
    numero_fat Utenza.numero_fattura%type;
    data_scad DATE := CURRENT_DATE + INTERVAL '7' DAY;

    CURSOR C IS (SELECT * FROM Sede);
BEGIN 
    FOR s IN C
    LOOP
        IF (s.stato_sede = 'ATTIVO') THEN
            importo := trunc(dbms_random.value(1, 999.99),2);
            numero_fat := dbms_random.string('X', 5);

            INSERT INTO Utenza(numero_fattura, 
                               fk_sede_via, 
                               fk_sede_civico, 
                               fk_sede_cap, 
                               importo_utenza, 
                               data_scadenza,
                               tipologia_utenza)
            VALUES(numero_fat, s.via_sede, s.civico_sede, s.cap_sede, importo, data_scad, 'ENEL-LUCE');

            importo := trunc(dbms_random.value(1, 999.99),2);
            numero_fat := dbms_random.string('X', 5);
            INSERT INTO Utenza(numero_fattura, 
                               fk_sede_via, 
                               fk_sede_civico, 
                               fk_sede_cap, 
                               importo_utenza, 
                               data_scadenza,
                               tipologia_utenza)
            VALUES(numero_fat, s.via_sede, s.civico_sede, s.cap_sede, importo, data_scad, 'ENEL-ELETTRICITA');
            
            importo := trunc(dbms_random.value(1, 999.99),2);
            numero_fat := dbms_random.string('X', 5);
            INSERT INTO Utenza(numero_fattura, 
                               fk_sede_via, 
                               fk_sede_civico, 
                               fk_sede_cap, 
                               importo_utenza, 
                               data_scadenza,
                               tipologia_utenza)
            VALUES(numero_fat, s.via_sede, s.civico_sede, s.cap_sede, importo, data_scad, 'ACQUA');
        END IF;
    END LOOP;
END;
