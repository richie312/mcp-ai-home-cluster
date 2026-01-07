# ADR-004: Redis as Materialized State Layer

**Architecture Decision Record**

## Status
Accepted

## Context
Kafka events are consumed once per consumer group.
The application UI requires re-readable, restart-safe state
and user-controlled lifecycle management.

## Decision
Introduce Redis as a materialized state layer between Kafka
and the application.

## Alternatives Considered
1. Query Kafka directly from the application
2. Store all state only in the database
3. Replay Kafka topics for UI rendering

## Consequences

### Positive
- UI becomes restart-safe
- Kafka offsets are decoupled from UI concerns
- Redis enables fast reads and controlled deletion

### Negative
- Additional component to operate
- Requires explicit lifecycle management
