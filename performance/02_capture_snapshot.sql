-- ============================================================
-- Capture one system status snapshot
-- ------------------------------------------------------------
-- Schedule this script periodically (for example every 15
-- minutes) with a job scheduler entry that runs RUNSQLSTM
-- against this source member or file.
--
-- RESET_STATISTICS => 'YES' makes the CPU value the average for
-- the interval since the previous call, so each row describes
-- that interval. Do not share the reset with other monitors
-- running in the same job.
--
-- Services used: QSYS2.SYSTEM_STATUS, QSYS2.SYSTEM_VALUE_INFO
-- ============================================================

INSERT INTO IBMIMON.SYSTEM_SNAPSHOT (
       HOST_NAME,
       ELAPSED_SECONDS,
       AVG_CPU_PCT,
       SYSTEM_ASP_USED_PCT,
       PERM_ADDRESS_RATE_PCT,
       TEMP_ADDRESS_RATE_PCT,
       TOTAL_JOBS,
       ACTIVE_JOBS,
       QPFRADJ)
SELECT S.HOST_NAME,
       S.ELAPSED_TIME,
       S.AVERAGE_CPU_UTILIZATION,
       S.SYSTEM_ASP_USED,
       S.PERMANENT_ADDRESS_RATE,
       S.TEMPORARY_ADDRESS_RATE,
       S.TOTAL_JOBS_IN_SYSTEM,
       S.ACTIVE_JOBS_IN_SYSTEM,
       (SELECT CURRENT_NUMERIC_VALUE
          FROM QSYS2.SYSTEM_VALUE_INFO
         WHERE SYSTEM_VALUE_NAME = 'QPFRADJ')
  FROM TABLE (
         QSYS2.SYSTEM_STATUS(RESET_STATISTICS => 'YES')
       ) S;
