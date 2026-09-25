-- ============================================================
-- Create the performance history table (run once)
-- ------------------------------------------------------------
-- Keeps periodic snapshots of system status so you can compare
-- periods, for example before and after an IBM i upgrade, or an
-- upgraded partition against one still on the previous release.
--
-- Change IBMIMON to the library you prefer. If you change it,
-- use the same name in 02_capture_snapshot.sql and
-- 03_daily_summary.sql.
-- ============================================================

CREATE SCHEMA IBMIMON;

CREATE TABLE IBMIMON.SYSTEM_SNAPSHOT (
  SNAPSHOT_TS            TIMESTAMP     NOT NULL DEFAULT CURRENT TIMESTAMP,
  HOST_NAME              VARCHAR(255),
  ELAPSED_SECONDS        INTEGER,
  AVG_CPU_PCT            DECIMAL(7, 2),
  SYSTEM_ASP_USED_PCT    DECIMAL(7, 2),
  PERM_ADDRESS_RATE_PCT  DECIMAL(7, 3),
  TEMP_ADDRESS_RATE_PCT  DECIMAL(7, 3),
  TOTAL_JOBS             INTEGER,
  ACTIVE_JOBS            INTEGER,
  QPFRADJ                INTEGER
);

LABEL ON TABLE IBMIMON.SYSTEM_SNAPSHOT
  IS 'IBM i system status snapshots';
