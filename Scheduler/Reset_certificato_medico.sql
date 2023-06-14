-- JOB CHE OGNI OGNI 5 GENNAIO RESETTA IL CERTIFICATO MEDICO 
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>      'Reset_Certificato_medico',
   job_type                 =>      'PLSQL_BLOCK',
   job_action               =>      'BEGIN 
                                        UPDATE Sottoscrizione SET certificato_medico = N;
                                    END;',
   start_date               =>      TO_DATE('05-01-2024','DD-MM-YYYY'),
   repeat_interval          =>      'FREQ=YEARLY', 
   enabled                  =>      TRUE,
   comments                 =>      'Reset a N del certificato medico');
END;
