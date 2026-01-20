
[Back to Roadmap](../ROADMAP.md)

# v1.0 Requirements — NVMe Recovery & Deterministic Redeployment

## Objective

Guarantee that the complete system can be redeployed on an NVMe-backed Raspberry Pi
in a deterministic, repeatable, and low-risk manner after hardware or OS failure.

This version focuses strictly on **infrastructure recovery and stability**.

---

## Functional Requirements

### R1 — Single Deployment Entry Point
- There must be exactly **one authoritative deployment trigger**
- Deployment must be runnable without manual intervention
- The trigger must be suitable for post-crash recovery scenarios

---

### R2 — Repository Restoration
- All required application repositories must be restorable automatically
- Repository sources must be explicitly defined
- Repository layout must be predictable after deployment

---

### R3 — Environment Configuration Recovery
- Application configuration must not be hardcoded in repositories
- Environment variables must be restorable from a trusted internal source
- Configuration recovery must not require manual editing

---

### R4 — Container Runtime Availability
- The system must ensure container runtime availability on a fresh OS
- Runtime setup must be idempotent (safe to re-run)
- User-level container execution must be supported

---

### R5 — Deterministic Container Startup
- All containers must start in a predictable order
- Service dependencies must be respected
- Startup behavior must be repeatable across reboots

---

### R6 — Persistent Storage on NVMe
- All stateful services must use named volumes
- Volumes must reside on NVMe-backed storage
- No critical data may depend on ephemeral filesystem paths

---

### R7 — Shared Network Topology
- All containers must communicate over a defined shared network
- Network configuration must be recreated deterministically
- No implicit or default bridge assumptions allowed

---

### R8 — Port Exposure & Firewall Alignment
- Exposed service ports must be explicitly declared
- Firewall rules must align with exposed ports
- No unnecessary ports may be opened

---

### R9 — System Observability (Operator-Level)
- Deployment completion must produce a clear success signal
- All UI-accessible services must be discoverable post-deployment
- Service access endpoints must be clearly presented to the operator

---

## Non-Functional Requirements

### NFR1 — Idempotency
- All deployment steps must be safe to re-run multiple times
- Partial failure must not corrupt system state

---

### NFR2 — Minimal Assumptions
- Deployment must assume only:
  - Fresh OS
  - Network connectivity
  - NVMe storage availability
- No manual pre-configuration expected

---

### NFR3 — Failure Recoverability
- A failed deployment must be restartable without cleanup
- No irreversible steps allowed

---

### NFR4 — Local-Network Trust Model
- Security assumptions are limited to a trusted local network
- No internet-facing hardening is required in v1.0

---

## Explicit Exclusions (Hard Boundaries)

The following are **out of scope for v1.0** and must not be introduced:

- Kafka feature enhancements
- Schema evolution
- Data analysis or reporting
- AI / GPT integration
- Multi-node orchestration
- Docker Swarm or Kubernetes
- UI redesign or frontend work
- Performance optimization


### R10 — Database Backup Restoration

**Requirement**

The system must support restoring a database from an existing SQL backup

The backup source must be accessible from the same Raspberry Pi

Restore must occur before dependent application containers start

**Constraints**

Backup file location must be explicit

Restore process must be repeatable

Restore must not require manual DB shell access

Non-Goals

No automated scheduled backups (out of scope)

No cross-node restore

Rationale

Ensures true disaster recovery, not just container recreation.

### R11 — GitHub Actions Runner as Container

**Requirement**

    GitHub Actions self-hosted runner must run as a Docker container

    Runner must survive host reboots

    Runner must be isolated from application containers

**Constraints**

Runner lifecycle must be independent of app lifecycle

Runner must not store state inside application volumes

**Non-Goals**

No autoscaling runners

No runner orchestration across nodes

**Rationale**

Ensures deployment trigger availability even after system rebuild.
---

## Exit Criteria (Release Gate)

v1.0 is considered complete **only if**:

- The system can be redeployed on a new NVMe-backed device
- No manual configuration steps are required
- All existing applications are running
- Existing Kafka and database services are operational
- Operator can access all known UIs immediately after deployment

---

## Definition of Done

> “If this device fails today, I can rebuild everything tomorrow calmly, predictably, and without improvisation.”

---

