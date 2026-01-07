⬅️ [Back to Phase 1 Requirements](./REQUIREMENTS_PHASE1.md)

# v1.2 Requirements — Job Data Ingestion & Normalization

## Version Metadata
- Phase: Phase 1
- Version: v1.2
- Status: PLANNED (to be frozen after review)
- Depends on: v1.1 (Data Flow Validation & Confidence Hardening)

---

## Purpose

Introduce **job data ingestion** and transform raw inputs into a
**clean, canonical, queryable dataset**.

This version focuses on **ingestion correctness and normalization**,
not intelligence or analysis.

---

## In-Scope Responsibilities

- Job ingestion from email sources
- Structured extraction into predefined schema
- Safe buffering via Kafka
- Transient state handling via Redis
- Durable storage in database

---

## Functional Requirements

### R1 — Email-Based Job Ingestion
- System must ingest job-related content from email sources
- Ingestion must be automatable
- Raw email content must not be queried directly by the application

---

### R2 — Structured Extraction
- Job data must be extracted into a **predefined schema**
- Extraction logic must tolerate:
  - Missing fields
  - Partial data
  - Format variance
- Invalid or incomplete records must not break ingestion flow

---

### R3 — Kafka as Ingestion Buffer
- Kafka must be used to buffer incoming job events
- Kafka decouples ingestion from processing
- Downstream consumers must not depend on ingestion timing

---

### R4 — Redis as Transient State
- Redis must store intermediate or recent job state
- Redis must not be treated as the source of truth
- Redis entries must be replaceable without data loss

---

### R5 — Database as Canonical Store
- Database must store normalized, durable job records
- Database schema must be authoritative
- Application queries for job data must rely on the database

---

### R6 — Deduplication Tolerance
- System must tolerate duplicate job entries
- Duplicate ingestion must not corrupt canonical data
- Deduplication logic may be best-effort (not perfect)

---

### R7 — Re-Ingestion Safety
- Re-running ingestion must not:
  - Corrupt existing data
  - Create inconsistent records
- Ingestion must be restart-safe

---

## Non-Functional Requirements

### NFR1 — Schema Consistency
- Schema changes are not allowed in v1.2
- All stored records must conform to the predefined schema

---

### NFR2 — Fault Tolerance
- Failure in ingestion must not affect:
  - Existing stored job data
  - Data pipeline stability
- Partial ingestion failures must be recoverable

---

### NFR3 — Clarity Over Throughput
- Throughput optimization is out of scope
- Correctness and data quality take priority

---

## Explicit Exclusions (Hard Boundaries)

The following are **not allowed** in v1.2:

- Skill extraction
- Trend analysis
- Ranking or scoring
- AI / GPT usage
- Personalization
- UI enhancements

---

## Exit Criteria (Release Gate)

v1.2 is complete only when:

- Job data is ingested reliably from email sources
- Data is stored in a normalized, canonical schema
- Duplicate and partial inputs are handled safely
- Re-ingestion does not break data integrity

---

## Definition of Done

> “I have clean job data that I can safely analyze next.”

---
<!--
REQUIREMENTS FREEZE NOTICE

Document: REQUIREMENTS_v1.2.md
Version: v1.2 FINAL
Phase: Phase 1
Status: FROZEN
Freeze Date: 2026-01-07

This document defines the FINAL and AUTHORITATIVE
requirements for v1.2 — Job Data Ingestion & Normalization.

Rules after freeze:
- No requirements may be added, removed, or modified
- No scope expansion is allowed
- Any changes must be introduced as a new version (v1.3+)

Rationale:
v1.2 exists to create a clean, canonical job data layer
before introducing intelligence, analysis,
