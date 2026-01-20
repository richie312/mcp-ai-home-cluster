                             +----------------------+
                             |   ai-agent-node      |
                             |----------------------|
                             | - AI Agent           |
                             | - Flask MCP Client   |
                             | - External Watcher A |
                             | - Swarm Worker       |
                             +----------+-----------+
                                        |
                                        | MCP Calls / Alerts
                                        v
+--------------------------------------------------------------------------+
|                          Docker Swarm Cluster                            |
|--------------------------------------------------------------------------|
|  manager-node                                                         |
|  (Swarm Manager + MCP Server)                                         |
|  -------------------------------------------------------------------  |
|  - Core Services: Kafka, Redis, Databases                             |
|  - Prometheus / Grafana                                               |
|  - Service Orchestration                                              |
+--------------------------------------------------------------------------+
| Worker Nodes:                                                            |
|                                                                          |
|  backup-node                                                             |
|  - Data Storage & Backups                                                |
|  - External Watcher B                                                    |
|  - Swarm Worker                                                          |
|                                                                          |
|  replica-node-1                                                          |
|  - Swarm Worker                                                          |
|  - Hosts replicated containers                                           |
|                                                                          |
|  replica-node-2                                                          |
|  - Swarm Worker                                                          |
|  - Hosts replicated containers                                           |
+--------------------------------------------------------------------------+

                     Monitoring & Alerting Layer
   --------------------------------------------------------------------
   Services → Prometheus → Grafana → PagerDuty → ai-agent-node

                     External Monitoring Layer
   --------------------------------------------------------------------
   - Watcher A: ai-agent-node (primary intelligent watcher)
   - Watcher B: backup-node (secondary heartbeat monitor)

                     Data & Backup Replication
   --------------------------------------------------------------------
   manager-node  <----sync---->  backup-node
   manager-node  <----sync---->  replica-node-1
   manager-node  <----sync---->  replica-node-2

