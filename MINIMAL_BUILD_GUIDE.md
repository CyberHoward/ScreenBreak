# Minimal Build Guide

This document tracks what features have been temporarily disabled to create a minimal buildable version of the ScreenBreak app.

## Purpose

The main app build was failing due to `ApplicationToken` not being found in scope. This minimal build comments out all FamilyControls-dependent code so you can:

1. Get the basic app structure compiling
2. Test the UI without Screen Time API features
3. Gradually re-enable features as you fix framework configuration

## What's Been Disabled

### Core Models
- **Session.swift** - ApplicationToken initializer and converter methods
- **AppSelection.swift** - FamilyActivitySelection conversion methods

### Services
- **ShieldManagementService.swift** - All shield and session management methods
- **AuthorizationService.swift** - All authorization methods
- **SessionMonitorService.swift** - Working but depends on disabled services

### ViewModels
- **GatekeeperViewModel.swift** - All access request and AI decision logic
- **OnboardingViewModel.swift** - Authorization and pact creation methods
- **SettingsViewModel.swift** - App management and authorization methods

### Views
- **RequestAccessView.swift** - Shows placeholder instead of blocked apps
- **IntentInputView.swift** - Shows placeholder
- **SessionTimerView.swift** - App token display commented out
- **MiniSessionTimerView** - Entire component commented out
- **FamilyPickerView.swift** - Shows placeholder
- **ShieldedAppsSelectionView.swift** - Shows placeholder instead of picker
- **ManageAppsView.swift** - Shows placeholder
- **BlockedAppCard** - Entire component commented out
- **ActiveSessionCard** - Entire component commented out

### App Initialization
- **ScreenBreakApp.swift** - Service initialization commented out
- **MyModel.swift** - FamilyActivitySelection properties and methods commented out

## How Features Appear in Minimal Build

1. **Home Tab** - Should work (basic UI)
2. **Gatekeeper Tab** - Shows "Feature disabled in minimal build" placeholder
3. **Settings Tab** - Should work but app management features disabled
4. **Insights Tab** - Should work (if not dependent on blocked apps)
5. **Onboarding** - Partially works, app selection step shows placeholder

## Re-enabling Features

To re-enable features after fixing the FamilyControls framework configuration:

### Step 1: Fix Framework Configuration
1. Ensure FamilyControls framework is properly linked in Xcode
2. Check that entitlements include Family Controls capability
3. Verify deployment target is iOS 16+ (or 15+ depending on API version)

### Step 2: Search and Uncomment
Search for these markers in your codebase:
- `// Commented out for minimal build`
- `/* COMMENTED OUT FOR MINIMAL BUILD`
- `// MINIMAL BUILD`

### Step 3: Re-enable in Order

1. **Core Models First**
   - Uncomment Session.swift ApplicationToken methods
   - Uncomment AppSelection.swift conversion methods
   
2. **Services Next**
   - Uncomment AuthorizationService
   - Uncomment ShieldManagementService
   
3. **ViewModels**
   - Uncomment GatekeeperViewModel
   - Uncomment OnboardingViewModel authorization methods
   - Uncomment SettingsViewModel
   
4. **Views Last**
   - Uncomment RequestAccessView
   - Uncomment IntentInputView
   - Uncomment SessionTimerView
   - Uncomment other gatekeeper views
   - Uncomment onboarding views
   - Uncomment settings views
   
5. **App Initialization**
   - Uncomment service initialization in ScreenBreakApp.swift

### Step 4: Incremental Testing
After uncommenting each section:
1. Build the project
2. Fix any compilation errors
3. Test the feature
4. Move to next section

## Files Modified

All modified files are marked with:
```swift
//  MINIMAL BUILD VERSION - FamilyControls features commented out
```

You can search for this string to find all files that need attention.

## Common Issues to Watch For

1. **Import statements** - Remember to uncomment `import FamilyControls` and `import ManagedSettings`
2. **Property initialization** - Some properties that depend on FamilyControls are commented out
3. **Method calls** - Views that call disabled methods will need to be updated
4. **Bindings** - Some @Binding properties are commented out and will need view updates

## Testing Minimal Build

The minimal build should:
- ✅ Compile successfully
- ✅ Launch without crashing
- ✅ Show basic UI
- ✅ Navigate between tabs
- ⚠️ Show placeholders for disabled features
- ❌ Not access Screen Time API

## Next Steps

1. Build and verify the minimal version compiles
2. Fix the underlying FamilyControls framework issue
3. Re-enable features one section at a time
4. Test incrementally as you re-enable features

