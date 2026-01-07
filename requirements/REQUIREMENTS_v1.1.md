
---

[Architecture](../architecture/ARCH_v1.1.md)

## In-Scope Responsibilities

- Kafka as **event ingestion layer**
- Redis as **materialized, re-readable state**
- Application as **state consumer and lifecycle controller**
- Database as **durable persistence**
- Restart safety across all components

---

## Functional Requirements

### R1 — Kafka Usage Constraints
- Kafka must be used strictly as an **event source**
- Kafka topics must not be queried directly by the application UI
- Application must not depend on Kafka offsets for UI correctness

---

### R2 — Redis as Materialized State
- Redis must store consumable, re-readable state derived from Kafka events
- Redis must survive application restarts
- Redis must act as the **primary read source** for the application UI

---

### R3 — Application-Controlled Redis Lifecycle
- Application must be able to:
  - Delete Redis entries
  - Expire Redis entries
- Lifecycle actions must be **explicit and intentional**
- Redis must not auto-delete data without application intent

---

### R4 — Restart Safety
- Restarting any single component must not:
  - Corrupt data
  - Cause duplicate state
  - Break UI consistency
- Supported restarts:
  - Application container
  - Redis container
  - Kafka container
  - Database container

---

### R5 — Idempotent Consumption
- Kafka consumers must be idempotent
- Reprocessing the same event must not create inconsistent Redis state
- Duplicate events must be tolerated safely

---

### R6 — Deterministic Data Flow
- Given the same input events:
  - Redis state must be reproducible
  - Application output must be consistent
- No hidden or time-dependent logic allowed

---

## Non-Functional Requirements

### NFR1 — Zero Manual Intervention
- No manual offset resets
- No manual Redis cleanup
- No manual DB fixes during normal operation

---

### NFR2 — Observability at Operator Level
- Operator must be able to verify:
  - Kafka is receiving events
  - Redis is populated
  - Application is reading from Redis
- Verification may be manual but must be **clear and deterministic**

---

### NFR3 — Stability Over Performance
- Performance optimizations are out of scope
- Correctness and predictability take priority

---

## Explicit Exclusions (Hard Boundaries)

The following are **not allowed** in v1.1:

- Schema evolution
- Analytics or reporting
- Skill extraction
- AI / GPT usage
- Autonomous workflows
- Infrastructure changes

---

## Exit Criteria (Release Gate)

v1.1 is complete only when:

- Data flows end-to-end without supervision
- Restarts do not break state consistency
- Redis accurately reflects consumed Kafka events
- Application UI behaves consistently after restarts

---

## Definition of Done

> “I trust the pipeline enough to stop watching it.”

---

<!--
REQUIREMENTS FREEZE NOTICE

Document: REQUIREMENTS_v1.1.md
Version: v1.1 FINAL
Phase: Phase 1
Status: FROZEN
Freeze Date: 2026-01-07

This document defines the FINAL and AUTHORITATIVE
requirements for v1.1 — Data Flow Validation & Confidence Hardening.

Rules after freeze:
- No requirements may be added, removed, or modified
- No scope expansion is allowed
- Any changes must be introduced as a new version (v1.2+)

Rationale:
v1.1
