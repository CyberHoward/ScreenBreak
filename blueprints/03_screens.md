# Key Screens & Components (Minimal v1)

Based on the flows in [02_flows.md](02_flows.md), these are the essential screens to implement:

#### **Onboarding Screens**
* **Welcome Screen**: Problem statement + value proposition
* **Motivation Input**: Text input for user's main motivation
* **Pact Configuration**: Duration selection, basic rules setup
* **Shielded Apps Selection**: Uses system `FamilyActivityPicker`
* **Confirmation Screen**: "Pact Started – Day X of Y"

#### **Main Dashboard**
* **`HomeView.swift`**: Main dashboard showing:
  - Current pact day and streak
  - Today's attempts count
  - Time used vs. daily limit

#### **Request Access View (AI Gatekeeper Chat)**
The unified chat interface for requesting access to blocked apps.

* **`RequestAccessView.swift`**: Main request access screen with integrated AI chat
  - **Top Section**: Displays up to 4 blocked apps as selectable chips
    - Multi-select support for requesting access to multiple apps at once
    - Shows active sessions count when applicable
    - Tapping an app chip toggles its selection
  - **Chat Section**: Full conversational AI interface
    - Messages scroll view with user and AI bubbles
    - Streaming AI responses
    - Typing indicator while AI processes
  - **Input Area**: Text and voice input
    - Text field with multi-line support
    - Voice recording button for speech-to-text
    - Send button
  - **Decision Result**: Appears when AI makes a decision
    - Access Granted: Shows time allowed and app count, "Done" button resets the chat
    - Access Denied: Shows supportive message and alternatives, "Got It" button resets
  
* **`GatekeeperChatViewModel.swift`**: Manages chat state and AI interaction
  - Multi-app selection support
  - Message history and streaming
  - Voice transcription integration
  - Session creation on approval

#### **Shield Interception**
* **Shield Overlay**: Static shield shown when user opens a blocked app
  - Simple message: "This app is blocked. Open ScreenBreak to request access."
  - Close button returns to home screen
  - User must manually open ScreenBreak to request access (Opal pattern)

#### **Settings**
* **`SettingsView.swift`**: Configuration hub
  - Manage shielded apps
  - View/adjust pact rules
  - Permissions management

#### **Background Extensions**
* **`ShieldConfigurationExtension.swift`**: Defines the shield overlay appearance
* **`DeviceActivityMonitorExtension.swift`**: Monitors app usage and triggers interventions
* **`AIChatService.swift`**: Handles communication with AI for intent evaluation

#### **Core Services**
* **`GatekeeperChatViewModel.swift`**: AI gatekeeper chat logic (only chat in the app)
* **`ShieldManagementService.swift`**: Manages app shields and temporary access
* **`MySchedule.swift`**: Manages pact configuration and active shields
* **`Persistence.swift`**: Stores session logs, attempts, and user data
