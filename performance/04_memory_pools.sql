-- ============================================================
-- Memory pools: size and faults
-- ------------------------------------------------------------
-- Shows each memory pool with its size and the activity measured
-- since the previous call (RESET_STATISTICS => 'YES').
-- Run it twice a few minutes apart: the second result shows the
-- activity of that interval.
--
-- What to look at: pool name and ID, current and defined size,
-- and the elapsed database and non-database fault columns.
-- High non-database faults in a pool usually point to a pool that
-- is too small for its workload, or to QPFRADJ settings that do
-- not match how the system is used.
--
-- Service used: QSYS2.MEMORY_POOL
-- Columns vary by release and PTF level, so the query returns all
-- of them. Once you know the names on your system, list only the
-- columns you need.
-- ============================================================

SELECT *
  FROM TABLE (
         QSYS2.MEMORY_POOL(RESET_STATISTICS => 'YES')
       ) P;
