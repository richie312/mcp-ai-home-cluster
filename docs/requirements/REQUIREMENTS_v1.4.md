⬅️ [Back to Phase 1 Requirements](./REQUIREMENTS_PHASE1.md)

# v1.4 Requirements — Training & Study Mapping

## Version Metadata
- Phase: Phase 1
- Version: v1.4
- Status: PLANNED (to be frozen after review)
- Depends on: v1.3 (Intelligence Layer — Analysis Only)

---

## Purpose

Translate **analytical insights** into a **clear, rational learning direction**
that helps prioritize effort without enforcing behavior.

This version introduces **guidance**, not control.

---

## In-Scope Responsibilities

- Skill gap identification
- Mapping skills to learning topics
- Time-bounded study roadmap generation
- Human-readable learning plans

---

## Functional Requirements

### R1 — Skill Gap Identification
- System must identify gaps between:
  - Skills in demand (from v1.3 insights)
  - Skills currently possessed (user-provided)
- Gaps must be explicit and explainable

---

### R2 — Learning Topic Mapping
- Each identified skill gap must map to:
  - Learning topics
  - Conceptual areas
- Mapping must be deterministic and transparent

---

### R3 — Study Roadmap Generation
- System must generate a study roadmap that:
  - Is time-bounded
  - Is sequential (what to learn first, next, later)
  - Reflects skill priority

---

### R4 — Effort Calibration
- Roadmap must estimate:
  - Relative effort per skill
  - Approximate time investment
- Estimates must be coarse-grained, not precise

---

### R5 — Human-Readable Output
- Outputs must be:
  - Clear
  - Non-prescriptive
  - Easy to understand
- Output must explain:
  - Why a skill is suggested
  - Why its priority is ranked as su

---

<!--
REQUIREMENTS FREEZE NOTICE

Document: REQUIREMENTS_v1.4.md
Version: v1.4 FINAL
Phase: Phase 1
Status: FROZEN
Freeze Date: 2026-01-07

This document defines the FINAL and AUTHORITATIVE
requirements for v1.4 — Training & Study Mapping.

Rules after freeze:
- No requirements may be added, removed, or modified
- No scope expansion is allowed
- Any changes must be introduced as a new version (v1.5+)

Rationale:
v1.4 exists to translate analytical insights into
clear, advisory learning direction without introducing
autonomy, enforcement, or behavioral pressure.
-->
