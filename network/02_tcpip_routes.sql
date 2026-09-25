-- ============================================================
-- Active TCP/IP routes and next hop
-- ------------------------------------------------------------
-- Shows the routes the system is using and the gateway
-- (next hop) behind each one.
--
-- Why it matters:
--   Dead Gateway Detection (CHGTCPA IPDEADGATE) only helps when
--   you have redundant routes through DIFFERENT gateways. If every
--   route, including *DFTROUTE, points to the same next hop, IBM
--   recommends IPDEADGATE(*NO). Check your environment first:
--   https://www.ibm.com/support/pages/ibm-i-dead-gateway-detection-overview-recommendations
--
-- Service used: QSYS2.NETSTAT_ROUTE_INFO
-- Columns vary by release and PTF level, so query 1 returns all of
-- them. Look at the destination, subnet mask, NEXT_HOP and route
-- status columns.
-- ============================================================

-- 1. All routes, all columns
SELECT *
  FROM QSYS2.NETSTAT_ROUTE_INFO;

-- 2. How many different gateways do you have?
--    Ignore direct (local subnet) routes. If only one real gateway
--    address remains, you have a single-gateway environment.
SELECT NEXT_HOP,
       COUNT(*) AS ROUTES
  FROM QSYS2.NETSTAT_ROUTE_INFO
 GROUP BY NEXT_HOP
 ORDER BY ROUTES DESC;
