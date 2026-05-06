# PostgreSQL Streaming Replication Setup

## Environment
- Primary: pg-primary (port 5432)
- Standby: pg-standby (port 5433)
- PostgreSQL Version: 16
- Platform: Docker Desktop (Windows)

## Step 1 — Configure Primary

### Create replication user
```sql
CREATE USER replicator WITH REPLICATION PASSWORD 'your_password';
```

### Update pg_hba.conf
