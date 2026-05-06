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
host replication replicator 0.0.0.0/0 scram-sha-256
### Verify WAL level
```sql
SHOW wal_level; -- should show replica
```

## Step 2 — Take Base Backup

Run from standby container:
```bash
pg_basebackup -h PRIMARY_IP -U replicator \
  -D /var/lib/postgresql/data -P -R \
  -e PGPASSWORD=your_password
```

`-R` flag automatically creates:
- `standby.signal` file
- `primary_conninfo` in postgresql.auto.conf

## Step 3 — Start Standby

```bash
docker start pg-standby
```

## Step 4 — Verify Replication

On primary:
```sql
SELECT client_addr, state, sync_state 
FROM pg_stat_replication;
-- state should show: streaming
```

Write on primary, confirm on standby:
```sql
-- Primary
INSERT INTO test (message) VALUES ('replication test');

-- Standby
SELECT * FROM test;
-- Row should appear
```

## Step 5 — Failover Simulation

### Kill primary
```bash
docker kill pg-primary
```

### Promote standby
```sql
SELECT pg_promote();
```

### Verify promotion
```sql
SELECT pg_is_in_recovery();
-- Should return false
```

## Lessons Learned

1. PostgreSQL 16 uses scram-sha-256 by default —
   pg_hba.conf must match, not md5

2. Container IP changes after restart —
   always use hostnames in production,
   not hardcoded IPs in primary_conninfo

3. After failover old primary becomes new standby —
   reconfigure it pointing to new primary

4. Monitor replication lag with:
```sql
SELECT sent_lsn - replay_lsn AS lag_bytes
FROM pg_stat_replication;
```

## Production Recommendations
- Use Patroni for automatic failover instead of manual pg_promote()
- Use hostnames not IP addresses in primary_conninfo
- Monitor replication slot lag to prevent disk full
- Set up alerting when lag_bytes exceeds threshold
