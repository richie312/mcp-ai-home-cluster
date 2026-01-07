# Project Roadmap — Frozen Planning Document

> **Goal**  
> Build a resilient, self-hosted job-intelligence and personal deployment platform, evolved safely after prior system failure, without wasting effort on premature optimization.

---

## Versioning Strategy

- **v1.x** → Single-node, NVMe-backed, deterministic deployment
- **v2.x** → Multi-node aware, AI-assisted, infra evolution
- **v3.x** → Optional UX & distribution polish

> Each version must satisfy its exit criteria before advancing.

---

# PHASE 1 — NVMe Recovery & Deterministic Deployment

## v1.0 — NVMe Redeployment (Recovery Baseline)

### Purpose
Recover from SD-card failure and guarantee repeatable resurrection of the entire system on NVMe SSD.

### Scope
Infrastructure stabilization only. No new features.

### Core Capabilities
- Single source of deployment truth
- Reproducible environment recovery
- Deterministic container bring-up
- Operational hardening
- Operator visibility

### Explicit Non-Goals
- Kafka enhancement
- Data analysis
- AI features
- Multi-node orchestration

### Exit Criteria
> System can be fully rebuilt on NVMe with zero guesswork.

### 📄 Requirements
- [v1.0 Requirements](./requirements/REQUIREMENTS_v1.0.md)
- [v1.0 Architecture](./architecture/ARCH_v1.0.md)
---

## v1.1 — Data Flow Validation (Kafka Utilization)

### Purpose
Ensure Kafka is functionally central, not decorative.

### Scope
End-to-end data movement only.

### Core Capabilities
- Active Kafka broker usage
- Producer → Kafka → Consumer flow
- UI-fed data pipeline

### Explicit Non-Goals
- Schema evolution
- Analytics
- AI processing

### Exit Criteria
> Data reliably moves from source to UI via Kafka.

---

## v1.2 — Job Data Ingestion & Normalization

### Purpose
Establish a clean, canonical job data layer.

### Scope
Controlled ingestion and storage.

### Core Capabilities
- Email-based job scraping
- Pre-defined schema enforcement
- Database persistence
- Kafka-backed ingestion buffer

### Explicit Non-Goals
- Trend prediction
- Skill analysis
- Study planning

### Exit Criteria
> Structured job data is trusted and queryable.

---

## v1.3 — Intelligence Layer (Analysis, Not Agents)

### Purpose
Convert job data into actionable insight.

### Scope
Analytical intelligence only.

### Core Capabilities
- Skill frequency analysis
- Temporal trend comparison
- GPT-assisted structured interpretation
- Decision-support outputs

### Explicit Non-Goals
- Autonomous agents
- Self-triggering workflows
- Infrastructure orchestration

### Exit Criteria
> System highlights skills that matter now.

---

## v1.4 — Personal Training & Study Mapping

### Purpose
Translate market intelligence into personal learning direction.

### Scope
Advisory recommendations only.

### Core Capabilities
- Skill gap identification
- Study plan generation
- Time-bound learning roadmap

### Explicit Non-Goals
- Habit enforcement
- Progress policing
- Gamification

### Exit Criteria
> Clear, rational learning path is produced.

---

## v1.5 — Documentation & Visual Identity

### Purpose
Make the system understandable to others.

### Scope
Representation and clarity.

### Core Capabilities
- Repository-level READMEs
- Architecture and pipeline diagrams
- Clear versioned narrative

### Explicit Non-Goals
- Marketing
- Public launch pressure

### Exit Criteria
> A competent engineer understands the system in minutes.

---

# PHASE 2 — AI-Enabled Cluster Evolution

## v2.0 — Intelligent Cluster Deployment

### Purpose
Improve resilience and manageability.

### Scope
Infrastructure evolution only.

### Core Capabilities
- Kafka → Confluent Kafka migration
- Local Kafka UI
- Cluster metadata database
- Node reliability tracking
- Docker Swarm orchestration

### Explicit Non-Goals
- Kubernetes migration
- Cloud dependency
- Full system autonomy

### Exit Criteria
> System adapts to node availability and failures.

---

## v2.1 — Offline & Remote Job Profiling

### Purpose
Enable offline-first remote job exploration.

### Scope
Data enrichment and profiling.

### Core Capabilities
- Offline job profile generation
- Remote role filtering
- Regional adaptability

### Exit Criteria
> Offline job profiles are usable and relevant.

---

# PHASE 3 — Frontend & Distribution (Optional)

## v3.0 — Mobile & Frontend UI

### Purpose
Accessibility and demonstration.

### Scope
User experience only.

### Core Capabilities
- React-based frontend
- Mobile-friendly UI
- PWA or Play Store deployment (optional)

### Explicit Non-Goals
- Monetization
- Social features

### Exit Criteria
> System is usable from mobile devices.

---

## Governing Principles

1. Stability before intelligence
2. Data before AI
3. Versioned progress over perfection
4. Infrastructure evolves only after failure evidence
5. No feature without exit criteria

---
