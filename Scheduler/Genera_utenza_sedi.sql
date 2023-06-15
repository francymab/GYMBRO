-- JOB CHE OGNI OGNI 4 MESI GENERA LE UTENZE PER OGNI SEDE ATTIVA 
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>      'Genera_Utenze_Sedi',
   job_type                 =>      'PLSQL_BLOCK',
   job_action               =>      'genera_utenza',
   start_date               =>      TO_DATE('01-01-2024','DD-MM-YYYY'),
   repeat_interval          =>      'FREQ=MONTHLY; INTERVAL=4', 
   enabled                  =>      TRUE,
   comments                 =>      'Genera le utenze per le sedi attive');
END;

