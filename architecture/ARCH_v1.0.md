[Back to RoadMap](../roadmap.md)

```mermaid

flowchart TB
    %% Control Plane
    subgraph CP["Deployment Control Plane"]
        GITHUB["GitHub Platform"]
    end

    %% Host System
    subgraph HOST["Raspberry Pi (NVMe-Backed)"]

        %% GitHub Runner
        subgraph RUNNER["CI Runner Layer"]
            GH_RUNNER["GitHub Actions Runner<br/>(Docker Container)"]
        end

        %% Bootstrap
        subgraph BOOT["Bootstrap & Initialization"]
            BS["Single Deployment Entry Point"]
        end

        %% Runtime
        subgraph RT["Container Runtime Layer"]

            subgraph STREAM["Streaming & State Layer"]
                KAFKA["Kafka"]
                REDIS["Redis"]
            end

            APP["Application"]
            DB["Database"]
        end

        %% Persistence
        subgraph PERSIST["Persistence Layer"]
            NVME["NVMe SSD<br/>Named Volumes"]
            DB_BACKUP["DB SQL Backup File"]
        end
    end

    %% Control Flow
    GITHUB --> GH_RUNNER
    GH_RUNNER --> BS
    BS --> RT

    %% Data Flow
    KAFKA --> REDIS
    REDIS --> APP
    APP --> REDIS
    APP --> DB

    %% Backup Restore
    DB_BACKUP --> DB


```