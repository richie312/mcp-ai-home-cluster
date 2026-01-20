@echo off
echo =====================================================
echo MCP-AI-HOME-CLUSTER - Initial Repository Setup
echo =====================================================

echo Creating base folders...

mkdir backups
mkdir backups\syncthing

mkdir configs
mkdir configs\templates

mkdir docs
mkdir docs\adr
mkdir docs\architecture
mkdir docs\requirements
mkdir docs\wiki

mkdir executor

mkdir mcp-client
mkdir mcp-client\app
mkdir mcp-client\app\routes
mkdir mcp-client\app\templates

mkdir mcp-server
mkdir mcp-server\src

mkdir monitoring
mkdir monitoring\grafana
mkdir monitoring\pagerduty
mkdir monitoring\prometheus

echo Creating initial files...

type nul > .gitignore
type nul > README.md

type nul > backups\README.md

type nul > configs\backups.yaml
type nul > configs\deployment.yaml
type nul > configs\example.env
type nul > configs\monitoring.yaml
type nul > configs\secrets-template.yaml
type nul > configs\settings.yaml

type nul > configs\templates\example.env
type nul > configs\templates\paths.yaml

type nul > docs\roadmap.md
type nul > docs\adr\ADR-004-redis-materialized-state.md

type nul > docs\architecture\ARCH_v1.0.md
type nul > docs\architecture\ARCH_v1.1.md

type nul > docs\requirements\REQUIREMENTS_v1.0.md
type nul > docs\requirements\REQUIREMENTS_v1.1.md
type nul > docs\requirements\REQUIREMENTS_v1.2.md
type nul > docs\requirements\REQUIREMENTS_v1.3.md
type nul > docs\requirements\REQUIREMENTS_v1.4.md
type nul > docs\requirements\REQUIREMENTS_v1.5.md

type nul > docs\wiki\Architecture.md
type nul > docs\wiki\Decisions.md
type nul > docs\wiki\Home.md
type nul > docs\wiki\Phase-1.md
type nul > docs\wiki\System-Overview.md
type nul > docs\wiki\v1.0-Recovery.md
type nul > docs\wiki\v1.1-Data-Flow.md
type nul > docs\wiki\v1.2-Ingestion.md
type nul > docs\wiki\v1.4-Study-Mapping.md
type nul > docs\wiki\v1.5-Documentation.md

type nul > executor\Dockerfile
type nul > executor\entrypoint.sh

type nul > mcp-client\Dockerfile
type nul > mcp-client\README.md
type nul > mcp-client\requirements.txt

type nul > mcp-client\app\ai_agent.py
type nul > mcp-client\app\app.py
type nul > mcp-client\app\mcp_client.py

type nul > mcp-client\app\routes\alert_routes.py
type nul > mcp-client\app\routes\main_routes.py

type nul > mcp-server\Dockerfile
type nul > mcp-server\README.md
type nul > mcp-server\requirements.txt
type nul > mcp-server\src\server.py

type nul > monitoring\README.md
type nul > monitoring\grafana\alerts.yml
type nul > monitoring\grafana\dashboards.json
type nul > monitoring\pagerduty\integration.md
type nul > monitoring\prometheus\prometheus.yml

echo =====================================================
echo Initial repository structure created successfully!
echo =====================================================

pause
