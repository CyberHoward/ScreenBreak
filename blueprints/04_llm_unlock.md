This is a **Technical Specification Document** optimized for an AI coding agent (like Cursor, Windsurf, or GitHub Copilot).

You can copy-paste this entire block directly into your AI coding tool to have it scaffold the feature.

---

# Technical Spec: Trigg AI Unlock Mechanism

**Target Library:** `MacPaw/OpenAI` (Swift)
**Context:** iOS Application (Trigg) - Section 2.2 Shielded App Interception.

## 1. Overview

This feature implements the **AI Gatekeeper**. When a user attempts to open a blocked app, the LLM evaluates their input. If the reason is valid, the LLM calls the function `unlock_shielded_app`. If invalid, the LLM returns standard text content (a denial message).

## 2. API Interface & Data Structures

### 2.1 The OpenAI Function Definition

The AI agent must define the function schema to be passed in the `tools` parameter of the `ChatQuery`.

* **Function Name:** `unlock_shielded_app`
* **Description:** "Call this function ONLY if the user's reason for opening the shielded app is valid according to the strictness rules. If denied, reply with text only."
* **Parameters (JSON Schema):**

| Parameter | Type | Description | Required |
| --- | --- | --- | --- |
| `target_app_name` | String | The name of the app being unlocked (e.g., "Instagram"). | Yes |
| `approved_duration` | Int | The session length in minutes (e.g., 5, 10, 15). | Yes |
| `display_message` | String | A short, punchy motivational phrase to show on the timer overlay. | Yes |
| `category_tag` | String | A categorization of the reason (e.g., "work", "communication", "entertainment"). | No |

### 2.2 Swift Decodable Model

The agent must generate a Swift struct to parse the JSON arguments returned by the LLM.

```swift
import Foundation

struct UnlockDecisionArguments: Codable {
    let target_app_name: String
    let approved_duration: Int
    let display_message: String
    let category_tag: String?
}

```

## 3. Service Layer Specification

The agent must create a service class `AIGatekeeperService` responsible for communicating with OpenAI.

### 3.1 Input Context

The service needs to accept the following context to build the prompt:

1. **User Input:** The text reason provided by the user.
2. **App Name:** The app they are trying to open.
3. **Strictness Level:** (Enum: `gentle`, `balanced`, `strict`).
4. **Time of Day:** Current local time.

### 3.2 Function Signature

The agent should implement this public method:

```swift
func evaluateAccessRequest(
    forApp appName: String,
    reason: String,
    strictness: StrictnessLevel,
    completion: @escaping (Result<GatekeeperDecision, Error>) -> Void
)

```

### 3.3 Return Type (Enum)

The service should map the raw OpenAI response into a clean Swift enum for the View Controller to handle.

```swift
enum GatekeeperDecision {
    case approved(duration: Int, message: String) // Function was called
    case denied(reason: String) // Function was NOT called, text returned
}

```

## 4. Prompt Engineering Spec

The agent must inject a System Message into the `ChatQuery` to enforce the logic.

**System Prompt Template:**

```text
Role: You are Trigg, a digital wellness assistant.
Context: The user is in a strictness mode of: {{STRICTNESS_LEVEL}}.
Current Time: {{CURRENT_TIME}}.

Task: The user wants to open {{APP_NAME}}. Their stated reason is: "{{USER_REASON}}".

Instructions:
1. Analyze the reason. Is it specific and necessary? Or is it vague/boredom?
2. If INVALID: Reply with a short, supportive refusal text explaining why. Do NOT call any tool.
3. If VALID: You MUST call the 'unlock_shielded_app' tool. 
   - Set 'approved_duration' to 5-15 mins based on necessity.
   - Set 'display_message' to a reminder of their goal.

```

## 5. Implementation Logic (Flow)

The AI Agent must implement the following flow within `evaluateAccessRequest`:

1. **Construct Tool:** Create `ChatTool` wrapping the `unlock_shielded_app` definition.
2. **Construct Messages:** * System Message (as defined in 4).
* User Message (User's input reason).


3. **Send Request:** Call `openAI.chats(query: ...)` including the `tools` parameter.
4. **Handle Response:**
* **Check `toolCalls`:** If `toolCalls` is not empty and name is `unlock_shielded_app`:
* Decode arguments into `UnlockDecisionArguments`.
* Return `.approved`.


* **Check `content`:** If `toolCalls` is empty but `content` exists:
* Return `.denied` using the content string.


* **Fallback:** If neither, return an error.
