[ALERT] CPU_USAGE_HIGH

Severity: HIGH
Host: server
Service: nginx-backend

Condition:
avg(cpu_usage_idle) < 5% for 5m

Current value:
cpu_usage = 96.4%

Started at: 2026-05-18 10:14:22 UTC

Description:
Sustained high CPU utilization detected on host.
Possible performance degradation.