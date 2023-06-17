-- JOB CHE OGNI PRIMO DEL MESE CANCELLA TUTTE LE PRENOTAZIONI PRECEDENTI DI DUE ANNI
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>      'Cancellazione_Prenotazioni',
   job_type                 =>      'PLSQL_BLOCK',
   job_action               =>      'BEGIN 
                                        DELETE FROM prenotazione 
                                        WHERE data_fine_attivita < SYSDATE-730;
                                    END;',
   start_date               =>      TO_DATE('01-01-2024','DD-MM-YYYY'),
   repeat_interval          =>      'FREQ=MONTHLY', 
   enabled                  =>      TRUE,
   comments                 =>      'Cancellazione delle vecchie prenotazioni');
END;
