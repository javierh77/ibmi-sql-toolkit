-- ============================================================
-- Gateway and connection events from the history log
-- ------------------------------------------------------------
-- 1. Gateway availability messages, such as TCP2615
--    "TCP/IP gateway not available", with exact timestamps.
-- 2. Gateway messages per day, for before/after comparisons,
--    for example after CHGTCPA IPDEADGATE(*NO) in a
--    single-gateway environment.
-- 3. TCP2617 "connection closed" messages grouped by remote
--    address. These are frequent and are kept apart so they do
--    not hide the gateway messages. A remote address closing
--    connections at a fixed interval usually points to a client,
--    monitor or agent that reconnects in a loop.
--
-- The remote address is extracted with a regular expression, so
-- query 3 works whatever the language of the message text.
--
-- Parameters: change the number of DAYS to the period you need.
-- Service used: QSYS2.HISTORY_LOG_INFO
-- Tested on IBM i 7.5.
-- ============================================================

-- 1. Gateway events (TCP26xx except connection closed)
SELECT MESSAGE_TIMESTAMP,
       MESSAGE_ID,
       MESSAGE_TEXT
  FROM TABLE (
         QSYS2.HISTORY_LOG_INFO(
           START_TIME => CURRENT TIMESTAMP - 30 DAYS)
       ) H
 WHERE MESSAGE_ID LIKE 'TCP26%'
   AND MESSAGE_ID <> 'TCP2617'
 ORDER BY MESSAGE_TIMESTAMP;

-- 2. Gateway events per day
SELECT DATE(MESSAGE_TIMESTAMP) AS EVENT_DATE,
       MESSAGE_ID,
       COUNT(*) AS EVENTS
  FROM TABLE (
         QSYS2.HISTORY_LOG_INFO(
           START_TIME => CURRENT TIMESTAMP - 30 DAYS)
       ) H
 WHERE MESSAGE_ID LIKE 'TCP26%'
   AND MESSAGE_ID <> 'TCP2617'
 GROUP BY DATE(MESSAGE_TIMESTAMP), MESSAGE_ID
 ORDER BY EVENT_DATE, MESSAGE_ID;

-- 3. Connections closed (TCP2617) per remote address and day
SELECT REGEXP_SUBSTR(MESSAGE_TEXT,
         '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') AS REMOTE_ADDRESS,
       DATE(MESSAGE_TIMESTAMP)  AS EVENT_DATE,
       COUNT(*)                 AS CLOSED_CONNECTIONS,
       MIN(MESSAGE_TIMESTAMP)   AS FIRST_EVENT,
       MAX(MESSAGE_TIMESTAMP)   AS LAST_EVENT
  FROM TABLE (
         QSYS2.HISTORY_LOG_INFO(
           START_TIME => CURRENT TIMESTAMP - 7 DAYS)
       ) H
 WHERE MESSAGE_ID = 'TCP2617'
 GROUP BY REGEXP_SUBSTR(MESSAGE_TEXT,
            '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'),
          DATE(MESSAGE_TIMESTAMP)
 ORDER BY CLOSED_CONNECTIONS DESC;
