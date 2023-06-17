CREATE OR REPLACE TRIGGER max_ore_settimanali
BEFORE INSERT ON Assegnazione_settimanale
FOR EACH ROW
DECLARE
        -- ECCEZIONI --
        -- Questa eccezione viene lanciata nel caso in cui il dipendente avesse superato le 48 ore settimanali --
	ore_sett_exc EXCEPTION;

	-- VARIABILI --
	ore_turno_ass NUMBER := 0;
	ore_nuova_ass NUMBER := 0;

BEGIN
	-- Sommiamo le ore di lavoro settimanali del dipendente
	SELECT SUM(ora_fine_turno - ora_inizio_turno) INTO ore_turno_ass
	FROM Tipologia_turno
	JOIN Assegnazione_settimanale
        ON nome_tipologia_turno = fk_tipologia_turno_nome
	WHERE fk_dipendente = :NEW.fk_dipendente;

	-- Selezioniamo le ore di lavoro del dipendente nel nuovo turno che si vorrebbe aggiungere --
	SELECT (ora_fine_turno - ora_inizio_turno) INTO ore_nuova_ass
	FROM Tipologia_turno 
	WHERE nome_tipologia_turno = :NEW.fk_tipologia_turno_nome;
	
	-- Se la somma tra le ore di lavoro assegnate e le nuove ore ottenute dal nuovo assegnamento --
	-- superano le 48 ore settimanali, lanciamo l'errore --
	IF( (ore_turno_ass + ore_nuova_ass) > 48) THEN
		RAISE ore_sett_exc;
	END IF;

EXCEPTION
WHEN ore_sett_exc THEN
	RAISE_APPLICATION_ERROR('-20119','ERRORE MAX ORE SETTIMANALI RAGGIUNTE PER QUESTO DIPENDENTE');

END;
