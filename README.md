# IBM i SQL Toolkit

Practical SQL scripts for IBM i administrators, built on **IBM i Services** (the `QSYS2` views and table functions).
They help you monitor system health, detect network issues, and prepare OS upgrades using plain SQL.

*Scripts SQL prácticos para administradores de IBM i. Resumen en español al final.*

## Contents

| Folder | Script | What it does |
| --- | --- | --- |
| `network` | `01_gateway_events.sql` | Lists TCP/IP gateway events (TCP26xx messages) from the history log |
| `network` | `02_tcpip_routes.sql` | Shows the active TCP/IP routes and their next hop |
| `performance` | `01_create_history_table.sql` | Creates a table to keep system status snapshots over time |
| `performance` | `02_capture_snapshot.sql` | Captures CPU, ASP, address rates, jobs, and QPFRADJ into the history table |
| `performance` | `03_daily_summary.sql` | Summarizes the snapshots per day and per system for before/after comparisons |
| `performance` | `04_memory_pools.sql` | Shows memory pool sizes and faults |
| `upgrade` | `01_ptf_groups_check.sql` | Lists installed PTF groups and flags key groups before an upgrade |

## How to use

1. Open **Run SQL Scripts** in IBM i Access Client Solutions (ACS).
2. Open the script, read the comments at the top, and adjust the parameters (for example, the number of days).
3. Run it on a test or non-production partition first.

### Build a performance baseline

The `performance` scripts create a simple history of system status. This is useful before and after an OS upgrade:

1. Change the schema name `IBMIMON` if you prefer another library, and run `01_create_history_table.sql` once.
2. Schedule `02_capture_snapshot.sql` to run periodically, for example every 15 minutes, using a job scheduler entry with `RUNSQLSTM` or `RUNSQL`.
3. After a few days, run `03_daily_summary.sql` to compare periods, or to compare an upgraded partition against a partition that stays on the previous release.

## Why these scripts

When you upgrade IBM i or move to the cloud, many problems appear first as small signals: a gateway marked as unavailable, a growing temporary address rate, an ASP filling up. Querying those signals with SQL turns them into data you can compare, share with your team, and send to IBM Support.

## Requirements and notes

- IBM i 7.4 or later with current Db2 PTF groups (IBM i Services are delivered and enhanced through PTFs).
- The user running the scripts needs the authority required by each IBM i Service.
- Column names and available services can vary between releases and PTF levels. If a script fails, check the IBM documentation for that service on your release.
- These scripts only read system information, except the `performance` scripts, which create and insert into their own history table.
- Always test on a non-production partition first. If a script does not work on your release, please open an issue with the release and the error message.

## Contributing

Suggestions and improvements are welcome. Open an issue or a pull request.

## Author

**Javier Herrera Cuellar**, IBM i specialist and consultant, Colombia.
[LinkedIn](https://www.linkedin.com/in/javier-herrera-cuellar-b092b39b/)

## License

MIT. See [LICENSE](LICENSE).

---

## Resumen en español

Colección de scripts SQL para administradores de IBM i, basados en **IBM i Services**. Sirven para monitorear el sistema, detectar problemas de red (como la caída intermitente de un gateway) y preparar actualizaciones de versión. Ejecútalos desde **Run SQL Scripts** en ACS, primero en una partición de pruebas. Los scripts de `performance` crean una tabla de historial para comparar el rendimiento antes y después de un upgrade.
