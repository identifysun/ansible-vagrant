#! /bin/bash
# https://harbor.example.com/#/project/createProject

HARBOR_USERNAME=admin
HARBOR_PASSWORD=Harbor12345

curl 'https://harbor.example.com/api/v2.0/projects' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: no-cache' \
  -H 'X-Resource-Name-In-Location: false' \
  --user "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" \
  --data-raw '{
  "project_name": "beijing",
  "public": true,
  "storage_limit": 0,
  "metadata": {
    "enable_content_trust": "false",
    "enable_content_trust_cosign": "false",
    "auto_scan": "true",
    "severity": "unknown",
    "retention_id": "string",
    "prevent_vul": "false",
    "public": "true",
    "reuse_sys_cve_allowlist": "string"
  }
}'


curl 'https://harbor.example.com/api/v2.0/projects/beijing/webhook/policies' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: no-cache' \
  -H 'X-Resource-Name-In-Location: false' \
  --user "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" \
  --data-raw '{
  "name":"harbor",
  "enabled":true,
  "event_types":[
    "SCANNING_FAILED",
    "SCANNING_COMPLETED",
    "SCANNING_STOPPED"
  ],
  "targets":[{
    "type":"http",
    "address":"https://harbor.example.com/jenkins/harbor-webhook/",
    "skip_cert_verify":true
  }]
}'


