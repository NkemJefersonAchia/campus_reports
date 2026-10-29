# Architecture Diagram

```mermaid
graph TB
    subgraph Presentation["Presentation Layer"]
        UI[Screens & Widgets]
        Shell[Shell Navigation]
        Router[GoRouter]
    end

    subgraph State["State Management Layer"]
        RP[Riverpod Providers]
        SP[StreamProviders]
        STP[StateProviders]
    end

    subgraph Data["Data Layer"]
        AR[AuthRepository]
        IR[IncidentRepository]
        NR[NotificationRepository]
    end

    subgraph Firebase["Firebase Backend"]
        FA[Firebase Auth]
        FS[Cloud Firestore]
        FST[Firebase Storage]
    end

    UI --> RP
    Shell --> Router
    Router --> RP
    RP --> SP
    RP --> STP
    SP --> AR
    SP --> IR
    SP --> NR
    AR --> FA
    AR --> FS
    IR --> FS
    IR --> FST
    NR --> FS
```

## Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| **Presentation** | UI widgets, screens, navigation shell, route configuration |
| **State Management** | Riverpod providers exposing reactive Firestore streams and local state |
| **Data** | Repository classes wrapping Firebase SDK calls, model serialization |
| **Firebase** | Authentication, real-time database, file storage |

## Data Flow

1. User interacts with a screen widget
2. Widget reads from a Riverpod provider (StreamProvider for real-time data)
3. Provider delegates to a Repository
4. Repository calls Firebase SDK
5. Firestore streams propagate changes back through the provider chain
6. UI rebuilds automatically via Riverpod's reactive rebuild
