sequenceDiagram
    autonumber
    Developer->>FastAPI: Request to /divide-celery
    FastAPI->>CeleryTask: Invoke divide.delay(a,b)
    Note over CeleryTask: Returns Task ID
    CeleryTask->>Redis: Push task
    loop Check Task
        Redis->>CeleryTask: Notify of task
    end
    Note right of CeleryTask: Process task
    CeleryTask->>Redis: Save result
    Developer->>FastAPI: Request to /query-task-status
    FastAPI->>Redis: Fetch result
    Redis-->>FastAPI: Return result
    FastAPI-->>Developer: Respond with result
    loop Poll for Tasks
        Flower->>Redis: Request all task details
        Redis-->>Flower: Return all tasks details
    end
    Developer->>Flower: View Dashboard
    Note over Flower: Shows tasks status
