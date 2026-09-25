-- ============================================================
-- Gateway events from the history log
-- ------------------------------------------------------------
-- Lists TCP/IP gateway messages (TCP26xx), such as TCP2615
-- "TCP/IP gateway not available", with their exact timestamps.
--
-- Use it to:
--   * Correlate network disconnections with user complaints
--   * Build a baseline before a configuration change
--   * Confirm that a change (for example, CHGTCPA IPDEADGATE(*NO)
--     in a single-gateway environment) had the expected effect
--
-- Parameter: change 7 DAYS / 30 DAYS to the period you need.
-- Service used: QSYS2.HISTORY_LOG_INFO
-- ============================================================

-- 1. Every gateway event, in order
SELECT MESSAGE_TIMESTAMP,
       MESSAGE_ID,
       MESSAGE_TEXT
  FROM TABLE (
         QSYS2.HISTORY_LOG_INFO(
           START_TIME => CURRENT TIMESTAMP - 7 DAYS)
       ) H
 WHERE MESSAGE_ID LIKE 'TCP26%'
 ORDER BY MESSAGE_TIMESTAMP;

-- 2. Events per day, useful for before/after comparisons
SELECT DATE(MESSAGE_TIMESTAMP) AS EVENT_DATE,
       MESSAGE_ID,
       COUNT(*) AS EVENTS
  FROM TABLE (
         QSYS2.HISTORY_LOG_INFO(
           START_TIME => CURRENT TIMESTAMP - 30 DAYS)
       ) H
 WHERE MESSAGE_ID LIKE 'TCP26%'
 GROUP BY DATE(MESSAGE_TIMESTAMP), MESSAGE_ID
 ORDER BY EVENT_DATE, MESSAGE_ID;
