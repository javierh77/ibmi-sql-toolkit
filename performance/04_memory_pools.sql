-- ============================================================
-- Memory pools: size and faults
-- ------------------------------------------------------------
-- Shows each active memory pool with its size and the faults
-- measured since the previous call (RESET_STATISTICS => 'YES').
-- Run it twice a few minutes apart: the first call starts the
-- interval (elapsed values are 0), the second one shows the
-- activity of that interval.
--
-- High non-database faults in a pool usually point to a pool that
-- is too small for its workload, or to QPFRADJ settings that do
-- not match how the system is used.
--
-- Service used: QSYS2.MEMORY_POOL
-- Tested on IBM i 7.5.
-- ============================================================

SELECT SYSTEM_POOL_ID,
       POOL_NAME,
       CURRENT_SIZE,
       DEFINED_SIZE,
       CURRENT_THREADS,
       MAXIMUM_ACTIVE_THREADS,
       PAGING_OPTION,
       ELAPSED_TIME,
       ELAPSED_DATABASE_FAULTS,
       ELAPSED_NON_DATABASE_FAULTS,
       ELAPSED_TOTAL_FAULTS,
       ELAPSED_ACTIVE_TO_WAIT,
       ELAPSED_WAIT_TO_INELIGIBLE,
       ELAPSED_ACTIVE_TO_INELIGIBLE
  FROM TABLE (
         QSYS2.MEMORY_POOL(RESET_STATISTICS => 'YES')
       ) P
 WHERE CURRENT_SIZE > 0          -- hides unused shared pools
 ORDER BY SYSTEM_POOL_ID;
