#!/usr/bin/env bash
set -euo pipefail

BASE_BFF="http://localhost:8082"
BASE_INSPECTOR="http://localhost:8080"
BASE_SMEV="http://localhost:8081"
TRACE_ID="webinar-trace-001"

echo "1) Login on Gateway"
LOGIN_RESPONSE=$(curl -sS -X POST "$BASE_BFF/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"demo"}')
echo "$LOGIN_RESPONSE"

TOKEN=$(echo "$LOGIN_RESPONSE" | sed -n 's/.*"accessToken":"\([^"]*\)".*/\1/p')
if [[ -z "$TOKEN" ]]; then
  echo "Cannot extract accessToken" >&2
  exit 1
fi

echo "2) Single passport check through Gateway with X-Trace-Id=$TRACE_ID"
CHECK_RESPONSE=$(curl -sS -X POST "$BASE_BFF/api/passport-checks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-Trace-Id: $TRACE_ID" \
  -H "Content-Type: application/json" \
  -d '{"extId":"client-001","personLastName":"Иванов","personFirstName":"Иван","personMiddleName":"Иванович","docSeriesNo":"0310","docNo":"559835"}')
echo "$CHECK_RESPONSE"

echo "3) Health endpoints"
curl -sS "$BASE_BFF/actuator/health"; echo
curl -sS "$BASE_INSPECTOR/actuator/health"; echo
curl -sS "$BASE_SMEV/actuator/health"; echo

echo "4) Prometheus endpoint samples"
curl -sS "$BASE_BFF/actuator/prometheus" | grep -E "http_server_requests_seconds_count|jvm_memory_used_bytes" | head || true
curl -sS "$BASE_INSPECTOR/actuator/prometheus" | grep -E "passport_checks|passport_jobs|http_server_requests_seconds_count" | head || true

echo "5) Container logs filtered by trace id"
docker logs queen-passport-bff 2>&1 | grep "$TRACE_ID" || true
docker logs queen-passport-inspector 2>&1 | grep "$TRACE_ID" || true
docker logs smev-api-mock 2>&1 | grep "$TRACE_ID" || true

echo "Prometheus: http://localhost:9090"
echo "Grafana:    http://localhost:3000  admin / 1234567890!"
echo "Dashboard:  Passport Inspector Observability"
