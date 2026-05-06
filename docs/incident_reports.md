# Production Incident Reports

## Incident 1 — Lock Contention
**Situation:** Transaction holding row lock without committing,
blocking other transactions.

**Detection:** pg_stat_activity showed blocked query with 
increasing wait duration. pg_blocking_pids() identified 
the blocking transaction.

**Resolution:** pg_cancel_backend() sent to blocking pid.
Blocking transaction rolled back.

**Prevention:** Set idle_in_transaction_session_timeout 
in postgresql.conf to auto-kill idle transactions.

---

## Incident 2 — Deadlock
**Situation:** Two transactions updating same rows in 
opposite order — circular lock dependency.

**Detection:** PostgreSQL automatically detected and 
terminated one transaction. Deadlock details in logs.

**Resolution:** PostgreSQL auto-resolved. Application 
fixed to always update rows in consistent order.

**Prevention:** Enforce consistent row update order 
in application code. Set deadlock_timeout lower 
for faster detection.

---

## Incident 3 — Table Bloat
**Situation:** Bulk delete caused 10,000 dead tuples 
to accumulate. Queries slowing down.

**Detection:** pg_stat_user_tables showed high n_dead_tup.
VACUUM reported rows "not yet removable" due to open 
transaction holding transaction horizon.

**Resolution:** Closed idle connections. Ran VACUUM VERBOSE.
Dead tuples dropped to zero.

**Prevention:** Monitor n_dead_tup regularly. Tune 
autovacuum_vacuum_scale_factor for frequently updated tables.
Close idle connections regularly.
