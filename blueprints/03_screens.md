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
  - Quick access to settings

#### **AI Gatekeeper Intervention**
* **`InterceptionView.swift`**: The screen that appears when user opens shielded app
  - Shows app being accessed
  - Question prompt: "What are you about to do on [App]?"
  - Text input or quick-select options
* **`AccessGrantedView.swift`**: Confirmation when AI allows access
  - Shows time limit granted (e.g., "You have 10 minutes")
  - Timer display
* **`AccessDeniedView.swift`**: Supportive denial message
  - Explanation of why access was denied
  - Suggested alternative actions
* **`MicroReflectionView.swift`**: Post-session quick check-in

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
* **`MySchedule.swift`**: Manages pact configuration and active shields
* **`Persistence.swift`**: Stores session logs, attempts, and user data