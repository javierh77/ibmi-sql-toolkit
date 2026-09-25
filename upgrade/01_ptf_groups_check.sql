-- ============================================================
-- PTF groups check before an IBM i upgrade
-- ------------------------------------------------------------
-- Lists the PTF groups installed on this partition and flags the
-- groups that usually matter most when you plan an upgrade or
-- run high-availability replication.
--
-- Run it on BOTH partitions (for example production and
-- contingency) and compare. A missing group on one side, such as
-- the High Availability group, is easy to overlook and can cause
-- problems with replication products.
--
-- Group numbers change by release, so this script matches on the
-- group description instead of hard-coded numbers.
--
-- Service used: QSYS2.GROUP_PTF_INFO
-- ============================================================

-- 1. Installed PTF groups, with key groups flagged
SELECT PTF_GROUP_NAME,
       PTF_GROUP_DESCRIPTION,
       PTF_GROUP_LEVEL,
       PTF_GROUP_TARGET_RELEASE,
       PTF_GROUP_STATUS,
       CASE
         WHEN UPPER(PTF_GROUP_DESCRIPTION) LIKE '%CUMULATIVE%'  THEN 'KEY: Cumulative'
         WHEN UPPER(PTF_GROUP_DESCRIPTION) LIKE '%HIPER%'       THEN 'KEY: HIPER'
         WHEN UPPER(PTF_GROUP_DESCRIPTION) LIKE '%DB2%'         THEN 'KEY: Db2'
         WHEN UPPER(PTF_GROUP_DESCRIPTION) LIKE '%SECURITY%'    THEN 'KEY: Security'
         WHEN UPPER(PTF_GROUP_DESCRIPTION) LIKE '%HIGH AVAIL%'  THEN 'KEY: High Availability'
         WHEN UPPER(PTF_GROUP_DESCRIPTION) LIKE '%JAVA%'        THEN 'KEY: Java'
         ELSE ''
       END AS KEY_GROUP
  FROM QSYS2.GROUP_PTF_INFO
 ORDER BY KEY_GROUP DESC, PTF_GROUP_NAME;

-- 2. Groups that are not fully applied
SELECT PTF_GROUP_NAME,
       PTF_GROUP_DESCRIPTION,
       PTF_GROUP_LEVEL,
       PTF_GROUP_STATUS
  FROM QSYS2.GROUP_PTF_INFO
 WHERE PTF_GROUP_STATUS <> 'INSTALLED'
 ORDER BY PTF_GROUP_NAME;

-- 3. Optional: compare with the latest levels published by IBM.
--    SYSTOOLS.GROUP_PTF_CURRENCY needs internet access from the
--    partition, so it may not work in every environment.
-- SELECT PTF_GROUP_ID, PTF_GROUP_TITLE, PTF_GROUP_LEVEL_INSTALLED,
--        PTF_GROUP_LEVEL_AVAILABLE, PTF_GROUP_CURRENCY
--   FROM SYSTOOLS.GROUP_PTF_CURRENCY
--  ORDER BY PTF_GROUP_CURRENCY DESC;
