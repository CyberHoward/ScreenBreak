# Transcription UI

Below is a concise, implementation-oriented summary of the **transcription (voice input) UI flow**, focusing on button layout, states, and user actions as observed in the current web and mobile experiences.

## 1. Entry Point (Idle State)

**Primary elements**

* **Text input field** (persistent, bottom-anchored).
* **Microphone button** adjacent to the input field.
* **Send button** (inactive until text or audio is present).

**User action**

* Tap/click **microphone** to initiate voice input.

**System response**

* Transition to recording state.
* Request microphone permission if not already granted.

---

## 2. Recording State (Active Transcription)

**Visual changes**

* Microphone icon transforms into a **recording indicator** (pulsing ring).
* Input field becomes **read-only** or visually deemphasized.
* A **timer** or subtle “listening” indicator may appear.

**Controls**

* **Tap recording indicator** → stop recording.
* **"X" button** appears to discard recording.

**Behavior**

* Audio is captured continuously.
* No text appears yet (or partial text appears only after stop).

---

## 3. Processing / Transcribing State

**Visual feedback**

* Recording indicator stops.
* **Loading / spinner** appears.
* UI remains locked to prevent duplicate actions.

**System behavior**

* Audio is sent for speech-to-text processing.
* Short latency (typically <1–2 seconds).

---

## 4. Review State (Text Inserted, Not Yet Sent)

**Result**

* Transcribed text is **inserted into the text input field**.
* Cursor is placed at the end of the text.

**Controls**

* **Edit text manually** (keyboard enabled).
* **Send button** becomes active.
* Microphone button returns to idle state (can re-record).

**User options**

* Edit for clarity or correctness.
* Append additional text (typed or via another voice input).
* Send immediately.

---

## 5. Submit State

**Action**

* Tap **Send**.

**System response**

* Message bubble appears in chat history.
* Standard ChatGPT response flow begins.

---

## 6. Error & Edge States

**Common cases**

* **Permission denied** → inline system prompt to enable mic access.
* **No speech detected** → brief toast or silent reset to idle.
* **Transcription failure** → retry prompt or silent fallback to text input.

**Design characteristics**

* Errors are **non-blocking** and minimally disruptive.
* User is always returned to a stable input state.

---

## Key UI Design Principles Observed

* **Single primary action** at each state (record → stop → send).
* **Mode clarity**: clear visual distinction between idle, recording, and processing.
* **Low cognitive load**: no branching choices during recording.
* **Immediate editability**: transcription is never auto-submitted.
* **Graceful failure**: errors reset cleanly without modal interruptions.
