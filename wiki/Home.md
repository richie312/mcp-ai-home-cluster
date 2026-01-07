# Job Intelligence System — Phase 1

## What This Is

This repository documents a **self-hosted job intelligence system** designed to:

- Recover deterministically after failure
- Ingest real-world job data
- Convert data into insights
- Translate insights into actionable learning direction
- Remain explainable, stable, and evolvable

This Wiki presents **Phase 1 only** of the system.

---

## Why This System Exists

Most job-search tools focus on:
- Listings
- Alerts
- Recommendations

This system focuses instead on **understanding the job market**:

- What skills are actually in demand?
- How do those skills change over time?
- What should *I* focus on learning next, and why?

The goal is **decision support**, not automation.

---

## Design Philosophy

Phase 1 is guided by a few core principles:

- **Stability before intelligence**
- **Data before AI**
- **Determinism over cleverness**
- **Explanation over automation**
- **Single-node first, evolve later**

Every architectural and design decision reflects these principles.

---

## High-Level Flow

At a conceptual level, the system operates as follows:

```mermaid

Job Sources
↓
Kafka (event stream)
↓
Redis (materialized state)
↔
Application (UI + interpretation)
↓
Database (durable storage)

```


Each layer has a **clear responsibility** and **explicit boundaries**.

---

## Phase 1 Scope

Phase 1 establishes a **complete, trustworthy foundation**.

It includes:

- Infrastructure recovery and hardening
- Reliable data flow
- Canonical job data ingestion
- Analytical intelligence (no agents)
- Advisory study mapping
- Clear documentation and system identity

It explicitly **does not include**:

- Autonomous agents
- Job recommendations
- Notifications
- Multi-node orchestration
- Mobile or frontend applications

---

## Phase 1 Versions

Phase 1 is intentionally broken into **small, composable versions**:

| Version | Focus |
|------|------|
| v1.0 | NVMe recovery & deterministic redeployment |
| v1.1 | Data flow validation & restart safety |
| v1.2 | Job data ingestion & normalization |
| v1.3 | Intelligence layer (analysis only) |
| v1.4 | Training & study mapping (advisory) |
| v1.5 | Documentation & system identity |

Each version adds **one capability**, and nothing more.

---

## How to Use This Wiki

This Wiki is structured like a **technical book**:

- Start with **System Overview**
- Read **Phase 1** to understand progression
- Dive into individual versions as needed
- Refer to **Architecture** for structure
- Refer to **Decisions** to understand *why* choices were made

All Wiki pages link back to **canonical Markdown files**
in the main repository for authoritative detail.

---

## Intended Audience

This documentation is written for:

- Software engineers
- System designers
- Reviewers evaluating architecture and thinking
- Future maintainers (including future-me)

It is **not** written as a tutorial or marketing artifact.

---

## Status

- Phase 1 planning: **Complete**
- Phase 1 requirements: **Frozen**
- Phase 1 architecture: **Final**
- Execution: **In progress / upcoming**

Future phases will build on this foundation without revisiting it.

---

## Where to Go Next

- 👉 **System Overview**
- 👉 **Phase 1**
- 👉 **Architecture**
- 👉 **Decisions (ADRs)**

This system values clarity over speed — and explanation over automation.
