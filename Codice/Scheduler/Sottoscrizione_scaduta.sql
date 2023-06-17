-- JOB CHE OGNI GIORNO CONTROLLA SE C'È QUALCHE SOTTOSCRIZIONE SCADUTA
BEGIN 
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>      'Sottoscrizione_scaduta',
   job_type                 =>      'PLSQL_BLOCK',
   job_action               =>      'BEGIN 
                                        UPDATE Sottoscrizione SET ha_pagato = N 
                                        WHERE data_fine_sottoscrizione = CURRENT_DATE;
                                    END;',
   start_date               =>      TO_DATE('19-06-2024','DD-MM-YYYY'),
   repeat_interval          =>      'FREQ=DAILY', 
   enabled                  =>      TRUE,
   comments                 =>      'Set a N ha_pagato delle sottoscrizioni scadute oggi');
END;

