# PostgreSQL DBA Lab

Hands-on PostgreSQL DBA practice environment built on Docker.
This repository documents real-world DBA scenarios I have 
implemented and tested.

## Environment
- PostgreSQL 16
- Docker Desktop (Windows)
- Two containers: pg-primary and pg-standby

## Topics Covered

### 1. Core Administration
- postgresql.conf tuning (shared_buffers, work_mem, WAL settings)
- pg_hba.conf authentication configuration
- Role-based access control (RBAC) — readonly, readwrite, admin roles
- User management and privilege assignment

### 2. Backup & Recovery
- Logical backup with pg_dump (plain and custom format)
- Physical backup with pg_basebackup
- Restore procedures with verification
- Automated backup script with retention management

### 3. Streaming Replication
- Primary and standby setup using pg_basebackup
- Replication monitoring with pg_stat_replication
- Failover simulation — primary crash and standby promotion
- pg_promote() and pg_is_in_recovery() verification

### 4. Performance Tuning
- Query optimization using EXPLAIN ANALYZE
- Index strategies — B-tree, composite, partial indexes
- Seq Scan to Index Scan improvement on 1M+ row datasets
- pg_stat_statements for slow query identification

### 5. Monitoring
- pg_stat_activity — live connection monitoring
- pg_stat_user_tables — bloat and vacuum monitoring
- Cache hit ratio monitoring
- Lock contention diagnosis with pg_blocking_pids()

### 6. Production Incident Simulations
- Lock contention and blocking query resolution
- Deadlock reproduction and diagnosis
- Table bloat detection and VACUUM
- Long running query identification and termination

### 7. Connection Pooling
- PgBouncer installation and configuration
- Transaction pooling mode
- Pool monitoring with SHOW POOLS

### 8. AWS RDS
- Free tier instance creation and connection
- Parameter groups configuration
- Manual snapshots
- Multi-AZ concepts

## Key Scripts

### Automated Backup Script
Daily backup with retention management and failure logging.
See: `scripts/pg_backup.sh`

### Daily Health Check
Monitoring queries for daily DBA routine.
See: `scripts/health_check.sql`

### Replication Setup
Step-by-step replication configuration.
See: `docs/replication_setup.md`

## Incident Reports
Documented root cause analysis for simulated incidents.
See: `docs/incident_reports.md`

## Skills Demonstrated
- PostgreSQL 16 administration
- Docker-based lab environment
- Backup and disaster recovery
- Streaming replication and failover
- Query performance optimization
- Production incident diagnosis
