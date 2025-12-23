# Minimal Build Guide

This document previously tracked what features were temporarily disabled to create a minimal buildable version of the ScreenBreak app.

## Current Status: ✅ FULLY RE-ENABLED

All FamilyControls and ManagedSettings features have been re-enabled as of the latest update.

## Files Updated

The following files have been updated to include full FamilyControls functionality:

### Core Models
- **Session.swift** - Full ApplicationToken support with `import ManagedSettings`
- **AppSelection.swift** - Full FamilyActivitySelection conversion with `import FamilyControls` and `import ManagedSettings`

### Services
- **ShieldManagementService.swift** - Full shield and session management with `import FamilyControls` and `import ManagedSettings`
- **AuthorizationService.swift** - Full authorization methods with `import FamilyControls`

### ViewModels
- **GatekeeperViewModel.swift** - Full access request and AI decision logic with `import FamilyControls` and `import ManagedSettings`
- **OnboardingViewModel.swift** - Full authorization and pact creation methods with `import FamilyControls` and `import ManagedSettings`
- **SettingsViewModel.swift** - Full app management and authorization methods with `import FamilyControls` and `import ManagedSettings`
- **HomeViewModel.swift** - Full storage features

### Views
- **RequestAccessView.swift** - Full blocked apps list and session cards with `import FamilyControls` and `import ManagedSettings`
- **IntentInputView.swift** - Full intent form with `import FamilyControls` and `import ManagedSettings`
- **SessionTimerView.swift** - Full app token display and MiniSessionTimerView with `import FamilyControls` and `import ManagedSettings`
- **FamilyPickerView.swift** - Full FamilyActivityPicker implementation with `import FamilyControls` and `import ManagedSettings`
- **ShieldedAppsSelectionView.swift** - Full app picker with `import FamilyControls` and `import ManagedSettings`
- **PactConfirmationView.swift** - Full authorization and createPact functionality
- **ManageAppsView.swift** - Full app management with `import FamilyControls` and `import ManagedSettings`
- **SettingsView.swift** - Full ManageAppsView sheet and danger zone
- **RestrictionView.swift** - Full FamilyControls features with `import FamilyControls` and `import ManagedSettings`
- **ConfigRestrictionsView.swift** - Full FamilyControls features with `import FamilyControls`
- **HomeView.swift** - Full ActiveSessionsCard
- **QuickActionsCard.swift** - Full ActiveSessionsCard component
- **ContentView.swift** - Full imports with `import FamilyControls` and `import ManagedSettings`

### App Initialization
- **ScreenBreakApp.swift** - Full service initialization with `import FamilyControls` and `import ManagedSettings`
- **MyModel.swift** - Full FamilyActivitySelection properties and methods with `import FamilyControls` and `import ManagedSettings`
- **MySchedule.swift** - Full shield restrictions and events

## Important Notes

### Import Requirements for ApplicationToken

When using `ApplicationToken` in Swift files, you **must** include:

```swift
import ManagedSettings
```

This is because `ApplicationToken` is defined in the ManagedSettings framework, not FamilyControls.

### Common Imports Pattern

Most files that interact with Screen Time features need:

```swift
import FamilyControls
import ManagedSettings
```

### Entitlements

Ensure your app has the following entitlements configured in Xcode:
- Family Controls capability
- App Groups (for extension communication)

### Deployment Target

The app requires iOS 16+ for full FamilyControls support.

## Testing the Full Build

The full build should:
- ✅ Compile successfully with all FamilyControls features
- ✅ Launch and request Screen Time authorization
- ✅ Allow app selection via FamilyActivityPicker
- ✅ Apply shields to selected apps
- ✅ Show blocked apps list with request access functionality
- ✅ Track and display active sessions
- ✅ Support the AI Gatekeeper flow
- ✅ Full onboarding with authorization and pact creation
- ✅ Full settings with app management and pact controls

