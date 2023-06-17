CREATE OR REPLACE PROCEDURE assegna_dipendente(numero_dipendente VARCHAR2,  
                                               data_assegnazione VARCHAR2, 
                                               nome_tipologia_turno VARCHAR2)  
AS 
    -- ECCEZIONI -- 
    -- Questa eccezione viene lanciata nel caso in cui la data inserita in input non appartiene ad una data -- 
    -- della settimana successiva a partire dalla settimana corrente  
    data_exc EXCEPTION; 
    -- Questa eccezione viene lanciata nel caso in cui il dipendente risulta licenziato -- 
    licenziato_exc EXCEPTION; 
	-- Questa eccezione viene lanciata nel caso in cui il dipendente sia un responsabile --
	responsabile_exc EXCEPTION;
 
    -- VARIABILI -- 
    data_assegnazioneX DATE := to_date(data_assegnazione, 'DD-MM-YYYY'); 
    data_lic DATE;
	mansione_dip Dipendente.mansione%type;
 
BEGIN 
    -- Controlliamo che il dipendente non sia licenziato e non sia un responsabile -- 
    SELECT data_di_licenziamento, mansione INTO data_lic, mansione_dip FROM dipendente WHERE fk_persona = numero_dipendente; 
     
    IF (data_lic IS NULL) THEN  
        RAISE licenziato_exc; 
	ELSIF(UPPER(mansione_dip) = 'RESPONSABILE') THEN
    	RAISE responsabile_exc;
    END IF; 
     
    -- Controlliamo la validità della data inserita in input. Se essa non appartiene alla settimana successiva -- 
    -- vuol dire che si sta cercando di assegnare il dipendente per un'altra settimana e non per quella successiva -- 
    -- alla data di oggi -- 
    IF(data_assegnazioneX NOT BETWEEN TRUNC(SYSDATE + 7,'D') + 1 AND TRUNC(SYSDATE + 7,'D') + 6) THEN 
        RAISE data_exc; 
    END IF; 
 
	-- Inseriamo i dati relativi all'assegnazione settimanale del dipendente -- 
    INSERT INTO Assegnazione_settimanale VALUES (data_assegnazioneX, numero_dipendente, nome_tipologia_turno); 
     
EXCEPTION 
    WHEN data_exc THEN 
        RAISE_APPLICATION_ERROR('-20011', 'DATA ASSEGNAZIONE NON COMPRESA NELL''ARCO TEMPORALE DELLA PROSSIMA SETTIMANA'); 
    WHEN licenziato_exc THEN 
        RAISE_APPLICATION_ERROR('-20012', 'DIPENDENTE LICENZIATO'); 
	WHEN responsabile_exc THEN
        RAISE_APPLICATION_ERROR('-20013', 'IL DIPENDENTE È UN RESPONSABILE');
END;
