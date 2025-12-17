# iOS Engineering Standards & Agentic Protocol:

**Version:** 1.0
**Context:** iOS 17+, Swift 5.9+, SwiftUI, Screen Time API (FamilyControls, ManagedSettings, DeviceActivity).

---

## 1. Agentic Coding Protocol

*Directives for AI Agents generating code for this project.*

### 1.1 Context Retention & Safety

* **No Hallucinations on APIs:** The Screen Time API is strict. Do not invent methods for `DeviceActivityMonitor` or `ShieldConfiguration`. If an API does not exist in the Apple Documentation, do not attempt to implement it.
* **Sandboxing Awareness:** Always assume code in **Extensions** (Shields, Monitors) has **NO network access** and **NO disk access** outside of the App Group.
* **Memory Constraints:** Extensions have a hard memory limit (approx. 6MB). Avoid large image assets or heavy frameworks (like Firebase) inside extensions.

### 1.2 Code Generation Style

* **Step-by-Step Logic:** When generating complex flows (e.g., Authorization -> Picker -> Monitor), comments must explain the *state change* before the code block.
* **Modular Generation:** Do not generate one massive `ContentView.swift`. Split code into `Components`, `Modifiers`, and `Services`.

---

## 2. Architecture Standards

### 2.1 Pattern: MVVM + Services

We use **Model-View-ViewModel (MVVM)** to separate UI from logic, with a **Service Layer** for system interactions.

* **View:** SwiftUI only. strictly passive.
* *Bad:* Calling `AuthorizationCenter.shared.requestAuthorization()` directly in a Button.
* *Good:* Calling `viewModel.requestPermissions()` which delegates to `AuthorizationService`.

* **ViewModel:** `@Observable` (iOS 17+) or `ObservableObject`. Holds state and handles user intent.
* **Model:** Codable structs. Data models must be shared via a Swift Package or a Shared File Target to be accessible by Extensions.

### 2.2 Data Persistence & Sharing

Since this app uses Extensions, data **must** be shared via App Groups.

* **User Defaults:** Use `UserDefaults(suiteName: "group.com.yourapp.screenbreak")` explicitly.
* **SwiftData / CoreData:** The container must be initialized with the App Group URL.
```swift
// Standard: PersistenceController.swift
let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yourapp.screenbreak")!
let storeURL = containerURL.appendingPathComponent("ScreenBreak.sqlite")

```

---

## 3. Screen Time API Standards (Blocking Core)

This is the most critical section for functionality.

### 3.1 FamilyControls (Authorization)

* **Privacy Policy:** The app **must** fail gracefully if the user denies authorization.
* **Scope:** Always request `.individual` authorization for personal focus apps.
* **Opaque Tokens:** Never attempt to decode `ApplicationToken` or `WebDomainToken`. They are device-specific and unreadable. They cannot be sent to a backend server.

### 3.2 ManagedSettings (The Shield)

* **Store Type:** Use a custom `ManagedSettingsStore` (named) rather than the default store to prevent conflicts with other apps.
```swift
let store = ManagedSettingsStore(named: .init("ScreenBreakStore"))

```


* **Shield Configuration:**
* UI is static. You cannot run animations or complex SwiftUI here.
* Use `ShieldConfigurationDataSource` to customize text/colors based on the `Application` or `Category` token.



### 3.3 DeviceActivity (The Trigger)

* **Schedules:** Intervals must be at least 15 minutes long to be reliable.
* **Monitor Extension:**
* **Reliability:** `intervalDidStart` and `intervalDidEnd` are not guaranteed to fire exactly on the second. Design logic to be resilient to 1-2 minute delays.
* **Forbidden:** Do not try to perform background network tasks (e.g., uploading usage stats) directly from `intervalDidEnd`.


* **Data Passing:** The Monitor Extension **cannot** read the main app's memory. It must read from `UserDefaults` (App Group) to know which apps to block.

### 3.4 Data Flow Diagram (App Group)

---

## 4. Swift Coding Style Guide

### 4.1 Syntax & Formatting

* **Type Safety:** Avoid `Any`. Use Generics or Protocols.
* **Unwrapping:** Avoid `force unwrap (!)` unless the app *should* crash if nil (e.g., missing bundle assets). Use `guard let` or `if let`.
* **Access Control:** Default to `private` or `private(set)` for properties. Expose only what is needed.

### 4.2 Naming Conventions

* **Boolean:** `isEnabled`, `hasAccess`, `isBlocking` (Prefix with verb).
* **Functions:** `fetchUserData()`, `configureShield()` (Verb + Noun).
* **Constants:** `static let maxRetryCount = 3` (camelCase).

### 4.3 Error Handling

* Do not use `try?` to silence errors silently in critical flows (like Authorization).
* Use a centralized `AppError` enum conforming to `LocalizedError`.

---

## 5. Security & Privacy Limitations

* **Network:** The Shield and DeviceActivity extensions are **network isolated**.
* **Sensitive Data:** Do not store plain-text usage logs. If usage data is needed for "Insights," aggregate it locally using `DeviceActivityReport` (which renders into a View, not raw data).
* **Bypass:** Be aware that users can bypass shields by deleting the app or removing the profile. The app should detect authorization revocation on launch:
```swift
// Check periodically
if AuthorizationCenter.shared.authorizationStatus == .denied {
    // Prompt re-onboarding
}

```



---

### Recommended Resource

For a deep dive into how these specific extensions communicate (or fail to communicate), this video is essential for understanding the strict boundaries Apple enforces.

[WWDC21: Meet the Screen Time API](https://www.youtube.com/watch?v=DKH0cw9LhtM)

**Relevance:** This is the foundational documentation for the framework you are using; it explicitly details the "Sandbox" constraints mentioned in Section 1.1 and 3.3 of the standards above.