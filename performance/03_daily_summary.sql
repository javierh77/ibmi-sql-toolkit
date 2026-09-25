-- ============================================================
-- Daily summary of the snapshots
-- ------------------------------------------------------------
-- Compares days and systems. Useful to answer questions like:
--   "Is production on the new release behaving like it did
--    before the upgrade?"
--   "Is the upgraded partition different from the one that
--    stayed on the previous release?"
--
-- If you collect snapshots from two partitions, copy the rows
-- into one table (or query each partition) and compare by
-- HOST_NAME.
-- ============================================================

SELECT HOST_NAME,
       DATE(SNAPSHOT_TS)                        AS DAY,
       COUNT(*)                                 AS SNAPSHOTS,
       DEC(AVG(AVG_CPU_PCT), 7, 2)              AS AVG_CPU_PCT,
       MAX(AVG_CPU_PCT)                         AS PEAK_CPU_PCT,
       MAX(SYSTEM_ASP_USED_PCT)                 AS MAX_ASP_USED_PCT,
       MAX(TEMP_ADDRESS_RATE_PCT)               AS MAX_TEMP_ADDR_PCT,
       MAX(PERM_ADDRESS_RATE_PCT)               AS MAX_PERM_ADDR_PCT,
       MAX(ACTIVE_JOBS)                         AS MAX_ACTIVE_JOBS,
       MIN(QPFRADJ)                             AS QPFRADJ_MIN,
       MAX(QPFRADJ)                             AS QPFRADJ_MAX
  FROM IBMIMON.SYSTEM_SNAPSHOT
 WHERE SNAPSHOT_TS >= CURRENT TIMESTAMP - 30 DAYS
 GROUP BY HOST_NAME, DATE(SNAPSHOT_TS)
 ORDER BY HOST_NAME, DAY;

-- Tip: if QPFRADJ_MIN and QPFRADJ_MAX differ on a day, someone
-- changed the automatic performance adjustment. Check it.
