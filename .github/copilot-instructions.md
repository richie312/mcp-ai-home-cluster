# Copilot Instructions for mcp-ai-home-cluster

## Project Overview
- This project is a multi-component AI home cluster, organized into service directories:
  - `mcp-server/`: Main backend server (see `src/server.py`).
  - `mcp-client/`: Client-side application and agents.
  - `executor/`: Likely for job/task execution (see `entrypoint.sh`).
  - `monitoring/`: Monitoring stack (Grafana, Prometheus, PagerDuty integration).
  - `configs/`: Centralized YAML configuration for deployments, monitoring, secrets, and templates.

## Architecture & Data Flow
- The system is service-oriented, with clear boundaries between server, client, executor, and monitoring.
- Data and configuration flow through YAML files in `configs/`.
- Monitoring is handled via Prometheus and Grafana, with alerting (see `monitoring/grafana/alerts.yml`).
- The server and client communicate via REST APIs (see `mcp-client/app/routes/`).

## Developer Workflows
- **Build/Run:**
  - Each service has its own `Dockerfile` for containerized builds.
  - Use `entrypoint.sh` in `executor/` for custom startup logic.
- **Configuration:**
  - All environment and deployment settings are in `configs/`.
  - Use `secrets-template.yaml` as a base for secrets.
- **Monitoring:**
  - Prometheus config: `monitoring/prometheus/prometheus.yml`
  - Grafana dashboards: `monitoring/grafana/dashboards.json`

## Conventions & Patterns
- **YAML-first configuration:** All major settings are in YAML, not `.env` or JSON.
- **Service isolation:** No cross-imports between `mcp-server/`, `mcp-client/`, and `executor/`.
- **API routes:** All client API endpoints are in `mcp-client/app/routes/`.
- **Documentation:**
  - Architecture and requirements are in `docs/` (see `docs/architecture/`, `docs/requirements/`).
  - Decisions and ADRs in `docs/adr/` and `docs/wiki/`.

## Integration Points
- **External:**
  - Prometheus, Grafana, PagerDuty (see `monitoring/`)
- **Internal:**
  - REST APIs between server and client
  - Executor invoked via scripts or container entrypoints

## Examples
- To add a new API route: create a file in `mcp-client/app/routes/` and register it in `app.py`.
- To update deployment: edit `configs/deployment.yaml` and rebuild the relevant Docker image.

---
For more details, see the `docs/` directory and YAML configs in `configs/`.
