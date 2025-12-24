Based on the core functionality of **Trigg** (an AI-powered app blocker using Screen Time APIs, DeviceActivity, and FamilyControls), this document outlines the minimal viable flows.

Trigg uses an **AI Gatekeeper** approach where users must state their intent before accessing shielded apps. The app operates on a **time-bound pact system** (e.g., 14-day commitments).

## Architectural Approach: User-Initiated Flow (Opal Pattern)

**Important:** Due to iOS Screen Time API limitations, we use a **user-initiated flow** similar to Opal:

1. **Shield shows static message**: "This app is blocked. Open ScreenBreak to request access" + Close button
2. **User manually opens ScreenBreak** when they want access to a blocked app
3. **User sees blocked apps list** and taps the one they want
4. **AI conversation happens** in ScreenBreak app (has network access)
5. **Access is granted or denied** based on AI evaluation

**Why this approach:**
- ✅ More reliable (no delays from extension callbacks)
- ✅ Simpler architecture (no complex App Group event communication)
- ✅ Better UX (user is in control and knows what to do)
- ✅ Easier to debug and maintain
- ✅ Works within iOS extension sandboxing constraints

**What we avoid:**
- ❌ No automatic triggering of main app from extension
- ❌ No notifications to wake the app
- ❌ No polling for pending attempts
- ❌ No unreliable `eventDidReachThreshold` timing issues

### 1. High-Level Site Map (Minimal Version)

This diagram represents the core screens needed for v1 functionality.

```mermaid
graph TD
    %% Nodes
    Launch[Launch Screen]
    Onboarding[Onboarding & Pact Setup]
    
    %% Main Views
    Dashboard[Dashboard / Home]
    Settings[Settings]
    
    %% Dashboard Sub-views
    TodaySummary[Today's Summary]
    PactProgress[Pact Progress]
    
    %% Settings Screens
    ShieldedApps[Manage Shielded Apps]
    PactRules[Pact Rules Config]
    Permissions[Permission Management]
    
    %% AI Gatekeeper (Intervention Flow)
    RequestAccess["Request Access View (AI Chat)"]
    ReasonInput[User Provides Reason]
    AIEvaluation[AI Evaluation]
    AllowedScreen[Access Granted Screen]
    DeniedScreen[Access Denied Screen]
    SessionTimer[Active Session w/ Timer]
    MicroReflection[Post-Session Reflection]

    %% Connections
    Launch --> Onboarding
    Onboarding --> Dashboard
    
    Dashboard --> TodaySummary
    Dashboard --> PactProgress
    Dashboard --> RequestAccess
    Dashboard --> Settings
    
    Settings --> ShieldedApps
    Settings --> PactRules
    Settings --> Permissions
    
    %% Gatekeeper Flow (user-initiated from Dashboard or when blocked)
    RequestAccess --> ReasonInput
    ReasonInput --> AIEvaluation
    AIEvaluation --> AllowedScreen
    AIEvaluation --> DeniedScreen
    AllowedScreen --> SessionTimer
    SessionTimer --> MicroReflection
    MicroReflection --> Dashboard
    DeniedScreen --> RequestAccess
```

---

### 2. Core User Flows (Minimal v1)

These diagrams represent the essential user journeys for the initial version.

#### **Flow A: Onboarding & Pact Setup**

The onboarding flow establishes the user's commitment and configures the AI gatekeeper.

```mermaid
sequenceDiagram
    participant User
    participant App
    participant System as iOS System (FamilyControls)
    
    User->>App: Opens App First Time
    App->>User: Show Welcome / Problem Statement
    App->>User: Explain AI Gatekeeper + Pact Model
    User->>App: Tap "Start Pact"
    
    App->>User: Input Motivation & Self-Assessment
    User->>App: Enters motivation (e.g., "better sleep")
    
    App->>User: Configure Pact Duration (e.g., 14 days)
    User->>App: Selects 14-day challenge
    
    App->>User: Select Shielded Apps
    User->>App: Picks apps (Instagram, TikTok, etc.)
    
    App->>User: Configure Basic Rules
    User->>App: Sets daily limit, per-session limit, strictness
    
    App->>System: Request FamilyControls Authorization
    System->>User: Show FaceID/Passcode Prompt
    User->>System: Authenticate & Approve
    System-->>App: Authorization Granted
    
    App->>User: Explain Shield Behavior
    Note over App,User: "When you open a blocked app,<br/>you'll see a shield screen.<br/>Just open ScreenBreak to request access!"
    
    App->>User: Show "Pact Started – Day 1 of 14"
    App->>User: Navigate to Dashboard

```

#### **Flow B: The AI Gatekeeper Flow (The Core Feature)**

This is the core flow where a user tries to open a shielded app and must explain their intent to the AI. Following the Opal pattern, the user manually opens ScreenBreak to request access.

```mermaid
flowchart TD
    Start((User Opens Shielded App)) --> Shield[Show Shield Screen]
    
    Shield --> ShieldMsg["Static Message:<br/>This app is blocked.<br/>Open ScreenBreak to request access"]
    
    ShieldMsg --> UserChoice{User Choice}
    UserChoice -- Taps Close --> Home[Returns to Home Screen]
    UserChoice -- Opens ScreenBreak --> AppList[Shows RequestAccessView]
    
    AppList --> BlockedApps[Display top 4 blocked apps as chips]
    BlockedApps --> Selection[User selects apps by tapping chips]
    Selection --> ChatInterface[AI Chat Interface]
    ChatInterface --> UserInput{User Provides Input}
    
    UserInput -- Text or Voice --> AIEval[AI Evaluation]
    UserInput -- Cancel --> AppList
    
    AIEval --> Context["Consider: time of day, recent usage,<br/>pact rules, strictness level"]
    
    Context --> Decision{AI Decision}
    
    Decision -- Allow --> Approve["Show: You have X minutes.<br/>Use it for what you said."]
    Decision -- Deny --> Deny["Show: Access denied +<br/>supportive explanation"]
    Decision -- Follow-up --> FollowUpQ[Ask clarifying question]
    
    FollowUpQ --> AIEval
    
    Approve --> RemoveShield[Temporarily remove app from shield]
    RemoveShield --> SessionActive[Session Timer Running in ScreenBreak]
    SessionActive --> UserSwitch[User switches to app]
    
    UserSwitch --> SessionEnd{Session Status}
    SessionEnd -- Timer Expires --> ReapplyShield[Re-apply Shield]
    SessionEnd -- User Returns Early --> ReapplyShield
    
    ReapplyShield --> Log[Log Session Data]
    Log --> MicroReflection[Optional: Micro-reflection prompt]
    MicroReflection --> End[Return to Dashboard]
    
    Deny --> SuggestAlt[Suggest Alternative Action]
    SuggestAlt --> AppList
    
    Home --> End

```

**Detailed Sequence Diagram:**

This shows the complete interaction between components in the simplified user-initiated flow.

```mermaid
sequenceDiagram
    participant User
    participant Shield as Shield Extension<br/>(Static UI)
    participant MainApp as ScreenBreak App
    participant AI as AI Service
    participant ShieldMgr as Shield Management<br/>Service
    participant Timer as Session Timer
    
    Note over User: User wants to open Instagram
    User->>Shield: Taps Instagram icon
    Shield->>User: Shows shield overlay<br/>"This app is blocked.<br/>Open ScreenBreak to request access"
    User->>Shield: Taps "Close" button
    Shield->>User: Returns to home screen
    
    Note over User: User manually opens ScreenBreak
    User->>MainApp: Opens ScreenBreak app
    MainApp->>User: Shows RequestAccessView<br/>(unified chat with app chips at top)
    
    User->>MainApp: Taps Instagram chip to select it
    MainApp->>User: Chip highlights as selected
    User->>MainApp: Types: "Reply to friend's message"
    
    MainApp->>AI: evaluateIntent(app: Instagram,<br/>intent: "Reply to...",<br/>context: pact rules + usage)
    AI-->>MainApp: Decision: ALLOW(minutes: 10)
    
    MainApp->>ShieldMgr: grantTemporaryAccess(Instagram, 10 min)
    ShieldMgr->>Shield: Remove Instagram from shield
    
    MainApp->>Timer: startSession(Instagram, 10 min)
    MainApp->>User: Shows AccessGrantedView<br/>"You have 10 minutes for Instagram"
    
    User->>User: Switches to Instagram
    Note over Shield: Instagram is now accessible
    
    Timer->>Timer: Counts down (10 min)
    
    alt User returns to ScreenBreak before timer ends
        User->>MainApp: Opens ScreenBreak
        MainApp->>User: Shows active session timer
    else Timer expires
        Timer->>ShieldMgr: Session expired
        ShieldMgr->>Shield: Re-apply shield to Instagram
        Note over Shield: Instagram blocked again
        Timer->>MainApp: Trigger micro-reflection
        MainApp->>User: "Did you use this time as intended?"
    end
    
    MainApp->>MainApp: Log session data<br/>(app, intent, duration, usage)
```

#### **Flow C: Managing Shielded Apps (Post-Onboarding)**

How a user modifies their shielded apps list after initial setup.

```mermaid
stateDiagram-v2
    [*] --> Settings
    Settings --> ShieldedAppsView : Tap "Manage Shielded Apps"
    
    ShieldedAppsView --> ViewList : Show current shielded apps
    
    ViewList --> AddApps : Tap "Add Apps"
    ViewList --> RemoveApp : Tap to remove app
    
    state AddApps {
        [*] --> FamilyPicker : Open FamilyActivityPicker
        FamilyPicker --> SelectApps : User selects apps
        SelectApps --> Confirm : Tap "Done"
    }
    
    AddApps --> ViewList : Apps added to shield list
    RemoveApp --> ViewList : App removed from shield list
    
    ViewList --> Settings : Tap "Back"
    Settings --> [*]

```
