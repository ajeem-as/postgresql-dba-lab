-- PostgreSQL Daily Health Check
-- Author: Ajeem A S

-- 1. Long running queries (over 5 minutes)
SELECT pid, usename, now() - query_start AS duration, 
       state, query
FROM pg_stat_activity
WHERE state = 'active' 
AND now() - query_start > interval '5 minutes';

-- 2. Tables with high dead tuples (bloat alert)
SELECT relname, n_live_tup, n_dead_tup,
       round(n_dead_tup * 100.0 / 
       nullif(n_live_tup + n_dead_tup, 0), 2) AS dead_pct,
       last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;

-- 3. Unused indexes (wasting space)
SELECT indexname, tablename,
       pg_size_pretty(pg_relation_size(indexrelid)) AS wasted_size
FROM pg_stat_user_indexes
WHERE idx_scan = 0;

-- 4. Cache hit ratio (should be above 95%)
SELECT round(sum(heap_blks_hit) * 100.0 /
       nullif(sum(heap_blks_hit) + 
       sum(heap_blks_read), 0), 2) AS cache_hit_ratio
FROM pg_statio_user_tables;

-- 5. Replication status
SELECT client_addr, state, 
       sent_lsn - replay_lsn AS lag_bytes,
       sync_state
FROM pg_stat_replication;

-- 6. Database sizes
SELECT datname, 
       pg_size_pretty(pg_database_size(datname)) AS size
FROM pg_database 
ORDER BY pg_database_size(datname) DESC;
