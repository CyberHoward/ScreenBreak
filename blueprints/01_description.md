# Description

This document outlines the description of the app, Trigg.

## 1. Core Concept

* **Trigg** is an **AI-powered app blocker** that:

  * Intercepts attempts to open specified “shielded” apps (Instagram, TikTok, etc.).
  * Forces a brief **reflection step** where the user must state why they’re opening the app.
  * Decides whether to **allow access with a time limit** or **block the attempt**, based on the user’s intent and rules.
* The app runs as a **time-bound commitment program** (e.g. 14-day “pacts”) to help users reset their relationship with social media and reclaim their attention.

---

## 2. Functional Modules

### 2.1 Onboarding & Pact Setup

**Goals:** Frame this as a serious but supportive commitment; configure the core behavior.

**Key steps:**

* Welcome screen explaining:

  * Problem: compulsive doomscrolling / hijacked attention.
  * Approach: AI gatekeeper + time-bound pact.
* User inputs:

  * Main motivation (e.g. better sleep, more focus, less guilt).
  * Self-assessment of current social media usage.
* Challenge configuration:

  * Select **challenge duration** (e.g. 14 days).
  * Explain **commitment model** (one-time payment / “pact”).
* Payment step:

  * User confirms they’re committing to the pact.
* Shielded apps selection:

  * User picks which apps to put behind the gate (Instagram, TikTok, X, YouTube, etc.).
* Rules & preferences:

  * Daily total time limit.
  * Per-session time limit (e.g. 5, 10, 15 minutes).
  * Strictness level (gentle / balanced / strict).
  * Optional “no social after X pm” quiet hours.
* Permissions:

  * Grant OS-level permissions needed for app blocking / tracking.
* Confirmation:

  * Show “Pact Started – Day 1 of 14” with a short summary of what will happen next.

---

### 2.2 Shielded App Interception (AI Gatekeeper Flow)

**Trigger:** User tries to open a shielded app.

**Flow:**

1. **Interception screen** replaces direct access to the app.

2. Trigg asks a **short question**, e.g.:

   * “What are you about to do on Instagram?”

3. User provides:

   * Quick text reason, **or**
   * Taps a predefined option (e.g. “Reply to messages”, “Post something”, “Just scrolling”, “Take a break”).

4. **AI evaluation:**

   * Interprets the reason + context (time of day, recent usage, pact rules, strictness).
   * Decides:

     * **Allow with timebox** (e.g. 5–10–15 minutes).
     * **Deny** and suggest an alternative action.
     * Optionally ask a **follow-up question** if the reason is vague or looks like self-justification.

5. **Outcome UI:**

   * If approved:

     * Show a clear message: “You have 10 minutes. Use it for what you said.”
     * Open the app with a timer running in the background.
   * If denied:

     * Show a supportive but firm message explaining why (“You already spent 45 minutes here today; let’s not add more.”).
     * Suggest a small alternative (e.g. “2-minute stretch”, “Return to current task”, “Short breathing break”).

6. **Emergency override (optional, configurable):**

   * User can bypass the AI in rare cases.
   * Requires friction (e.g. long press, type a phrase).
   * Logged clearly as an override event in the stats.

---

### 2.3 Time-Boxed Session Management

**When access is granted:**

* A **session timer** starts for that app.
* User may see:

  * A subtle overlay / notification showing remaining time.
  * Periodic reminder (“3 minutes left”).
* When the timer ends:

  * App is automatically blocked again or user is nudged to exit.
  * Trigg shows a **micro-reflection**:

    * “Did you use this time as you intended?” (Yes/No)
    * Optional short note.

All sessions are logged with:

* App name
* Start/stop time
* Time allowed vs. time used
* Stated reason
* AI decision (allow/deny)

---

### 2.4 Challenge Tracking & Progress

**Challenge state:**

* Current day of the pact (e.g. Day 7 of 14).
* Streak (consecutive days without breaking the pact rules).

**Metrics tracked:**

* Attempts to open shielded apps per day.
* Successful vs. denied attempts.
* Total time spent in shielded apps.
* **Time “saved”** relative to limits.
* Most common reasons (e.g. “bored”, “avoiding work”, “messaging”).

**User-facing views:**

* Simple **daily summary**:

  * “You tried to open shielded apps 9 times today.”
  * “You spent 26 minutes in them (limit: 30 minutes).”
* **Progress summary** over the whole pact:

  * Graphs or simple charts.
  * Highlighted insights: “Your late-night urges (after 23:00) dropped by 40%.”

---

### 2.5 Dashboard & Insights

**Home / dashboard screen shows:**

* Today at a glance:

  * Attempts today.
  * Time used vs. time limit.
  * Time saved.
  * Pact day + streak.
* Short insight cards:

  * “Most urges happen between 22:00–01:00.”
  * “Most common reason: ‘just bored’.”
* Buttons / navigation:

  * View detailed stats.
  * Adjust rules (if allowed mid-pact).
  * Write a reflection.

**Detailed insights view:**

* Filters by:

  * Date range.
  * Specific apps.
* Charts:

  * Attempts over time.
  * Time spent vs. limits.
  * Reasons distribution.
* Textual summaries:

  * Simple, human language interpretation of patterns.

---

### 2.6 Settings & Configuration

**User can:**

* Modify **shielded apps** list.
* Adjust:

  * Daily time limits.
  * Per-session time limits.
  * Quiet hours.
  * Strictness level (within constraints of active pact rules).
* Manage notifications:

  * Daily summary.
  * “End-of-day reflection.”
  * Reminder when trying to open apps during quiet hours.

**Challenge management:**

* Start a new pact (after finishing the current one).
* Extend or upgrade to a longer pact (if supported).
* End or cancel a pact early (with clear messaging about breaking the commitment).

---

### 2.7 Monetization-Linked Interactions (High-Level)

* **Free mode (if present):**

  * Basic tracking and light prompts.
  * No strict app blocking or AI-based deny decisions.
  * Upsell when user tries to:

    * Turn on strict blocking.
    * Start a full pact.

* **Paid pact:**

  * Full AI gatekeeping, timeboxing, and insights.
  * Payment/upsell screens appear:

    * At the end of onboarding when starting a pact.
    * When user hits feature limits in free mode.

---

### 2.8 Tone & UX Principles (for copy / micro-interactions)

* **Empowered, not shaming.**
* **Playful accountability:** slightly provocative, but supportive.
* Messages acknowledge:

  * “The system is designed to hijack you.”
  * “You’re choosing to reclaim control.”
* Short, punchy microcopy:

  * “Why are you really opening this?”
  * “You said you wanted better sleep. Let’s keep that promise.”
  * “Don’t watch it. Live it.”

### Marketing

• Elevator Pitch: An AI-powered app blocker that intercepts your urges to open social media, forces you to explain why, and only lets you in with a timebox when it aligns with your goals—so you stop doomscrolling and start using your attention intentionally.
• Target Audience: Self-aware heavy social media users (roughly 18–40, knowledge workers, students, and creatives) who feel out of control with their scrolling, have tried simple blockers before, and are now motivated enough to commit to a structured reset.
• Core Value: ScreenBreak breaks compulsive, unconscious social media use at the moment of the trigger by adding reflective friction—helping users reclaim their time, focus, and sense of agency over their own attention."

## Device Scope

Device Support: iPhone only for v1 (native iOS app, optimized for iPhone).
• Orientation: Portrait-only experience (landing screens, dashboards, and gatekeeper interactions designed for one-handed use).
• Minimum iOS Version: iOS 17+ (to leverage the latest Screen Time / app blocking APIs and notification behaviors)."
