# Firestore Data Model Diagram

```mermaid
erDiagram
    USERS {
        string uid PK
        string fullName
        string email
        string role "student | staff"
        string department
        string photoUrl
        timestamp createdAt
    }

    INCIDENTS {
        string id PK
        string title
        string description
        string category
        string location
        string locationDetail
        string photoUrl
        string priority "normal | urgent"
        boolean isAnonymous
        string status "Submitted | In Progress | Resolved | Rejected"
        string reporterId FK
        string reporterName
        timestamp createdAt
        timestamp updatedAt
        timestamp resolvedAt
        string assignedTo FK
    }

    STATUS_HISTORY {
        string id PK
        string status
        string note
        string changedBy FK
        string changedByName
        timestamp timestamp
    }

    NOTIFICATIONS {
        string id PK
        string userId FK
        string incidentId FK
        string title
        string body
        boolean isRead
        timestamp createdAt
    }

    USERS ||--o{ INCIDENTS : "reports"
    USERS ||--o{ NOTIFICATIONS : "receives"
    INCIDENTS ||--o{ STATUS_HISTORY : "has"
    INCIDENTS ||--o{ NOTIFICATIONS : "triggers"
```

## Collections

| Collection | Description | Key Indexes |
|-----------|-------------|-------------|
| `users/{uid}` | User profiles | — |
| `incidents/{id}` | Incident reports | `reporterId` + `createdAt` desc, `createdAt` desc |
| `incidents/{id}/statusHistory/{entryId}` | Status change audit trail | `timestamp` asc |
| `notifications/{id}` | In-app notifications | `userId` + `createdAt` desc, `userId` + `isRead` |
