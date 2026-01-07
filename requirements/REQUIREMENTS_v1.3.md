⬅️ [Back to Phase 1 Requirements](./REQUIREMENTS_PHASE1.md)

# v1.3 Requirements — Intelligence Layer (Analysis Only)

## Version Metadata
- Phase: Phase 1
- Version: v1.3
- Status: PLANNED (to be frozen after review)
- Depends on: v1.2 (Job Data Ingestion & Normalization)

---

## Purpose

Transform **clean, canonical job data** into **decision-grade insights**
that help identify **what skills matter, how they change over time,
and where focus should be applied next**.

This version introduces **analysis only**, not autonomy.

---

## In-Scope Responsibilities

- Analytical processing of job data stored in the database
- Derivation of insights from historical and current job records
- Human-readable outputs for decision-making
- GPT usage strictly as an **analysis assistant**, not a controller

---

## Functional Requirements

### R1 — Skill Extraction
- System must extract skills from job records
- Extraction must rely on structured job fields and descriptions
- Missing or ambiguous skills must be handled gracefully

---

### R2 — Skill Frequency Analysis
- System must compute frequency of skills across job records
- Frequency must be:
  - Countable
  - Comparable across time windows
- Analysis must not mutate source data

---

### R3 — Temporal Trend Analysis
- System must support comparison of skill demand across time periods
- Trends must highlight:
  - Emerging skills
  - Declining skills
  - Stable skills
- Time windows must be configurable at analysis time

---

### R4 — GPT-Assisted Interpretation (Bounded)
- GPT may be used to:
  - Summarize analytical results
  - Interpret trends into human-readable insights
- GPT must not:
  - Trigger workflows
  - Modify data
  - Make decisions autonomously

---

### R5 — Deterministic Analysis
- Given the same dataset:
  - Analytical outputs must be reproducible
  - GPT prompts must be deterministic and versioned
- No hidden randomness allowed in core metrics

---

### R6 — Insight Output
- Outputs must be:
  - Human-readable
  - Explainable
  - Traceable to underlying data
- Outputs must clearly separate:
  - Raw metrics
  - Interpretations
  - Assumptions

---

## Non-Functional Requirements

### NFR1 — Read-Only Data Access
- Analysis must not modify:
  - Kafka data
  - Redis state
  - Database records
- Analysis operates on **read-only views**

---

### NFR2 — Stability Over Sophistication
- Advanced statistical models are out of scope
- Simple, explainable analysis is preferred

---

### NFR3 — Transparency
- No black-box scoring
- Every insight must be explainable in plain language

---

## Explicit Exclusions (Hard Boundaries)

The following are **not allowed** in v1.3:

- AI agents
- Autonomous decisions
- Job ranking or recommendation engines
- Study plans or learning paths
- Infrastructure changes
- UI feature expansion

---

## Exit Criteria (Release Gate)

v1.3 is complete only when:

- Skill frequency metrics are accurate and repeatable
- Skill trends can be compared across time windows
- GPT summaries reflect underlying data faithfully
- Insights help answer:  
  **“What skills matter most right now?”**

---

## Definition of Done

> “The system produces insights I would trust to guide my focus.”

---
<!--
REQUIREMENTS FREEZE NOTICE

Document: REQUIREMENTS_v1.3.md
Version: v1.3 FINAL
Phase: Phase 1
Status: FROZEN
Freeze Date: 2026-01-07

This document defines the FINAL and AUTHORITATIVE
requirements for v1.3 — Intelligence Layer (Analysis Only).

Rules after freeze:
- No requirements may be added, removed, or modified
- No scope expansion is allowed
- Any changes must be introduced as a new version (v1.4+)

Rationale:
v1.3 exists to convert normalized job data into
decision-grade insights without introducing autonomy,
agents, or behavioral side effects.
-->
