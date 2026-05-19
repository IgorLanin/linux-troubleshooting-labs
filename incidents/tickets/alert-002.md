[ALERT] SERVICE_DOWN

Severity: CRITICAL
Host: server
Service: nginx

Condition:
service_status != running for 2m

Current state:
inactive (dead)

Last check:
2026-05-18 10:25:03 UTC+3

Error:
connection refused / upstream unavailable

Description:
Service is not responding to health checks.