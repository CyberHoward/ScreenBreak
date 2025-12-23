//
//  GatekeeperAIService.swift
//  ScreenBreak
//
//  AI service for evaluating user intents and making access decisions
//

import Foundation
import OpenAI

final class GatekeeperAIService {
    private let chatService: AIChatService
    
    init(chatService: AIChatService = AIChatService()) {
        self.chatService = chatService
    }
    
    // MARK: - Decision Types
    
    enum GatekeeperDecision {
        case allow(minutes: Int, message: String)
        case deny(reason: String, alternatives: [String])
        case followUp(question: String)
    }
    
    struct SessionContext {
        let pact: Pact
        let appName: String
        let todayUsageMinutes: Int
        let recentAttempts: Int
        let currentHour: Int
        let currentMinute: Int
    }
    
    // MARK: - Main Evaluation Method
    
    func evaluateIntent(
        intent: String,
        appName: String,
        context: SessionContext
    ) async throws -> GatekeeperDecision {
        let systemPrompt = buildSystemPrompt(context: context)
        let userPrompt = buildUserPrompt(intent: intent, appName: appName, context: context)
        
        let messages: [ChatQuery.ChatCompletionMessageParam] = [
            ChatQuery.ChatCompletionMessageParam(role: .system, content: systemPrompt)!,
            ChatQuery.ChatCompletionMessageParam(role: .user, content: userPrompt)!
        ]
        
        // Get AI response
        var fullResponse = ""
        let stream = chatService.streamReply(messages: messages)
        
        for try await chunk in stream {
            fullResponse += chunk
        }
        
        // Parse the response into a decision
        return parseDecision(from: fullResponse, context: context)
    }
    
    // MARK: - Prompt Building
    
    private func buildSystemPrompt(context: SessionContext) -> String {
        let pact = context.pact
        let strictnessGuidance = getStrictnessGuidance(pact.rules.strictness)
        
        return """
        You are a supportive AI gatekeeper helping a user achieve their goal: "\(pact.motivation)".
        
        **Pact Details:**
        - Duration: \(pact.durationDays) days
        - Current Day: \(pact.currentDay) of \(pact.durationDays)
        - Streak: \(pact.streak) days
        - Daily Limit: \(pact.rules.dailyLimitMinutes) minutes
        - Session Limit: \(pact.rules.sessionLimitMinutes) minutes max per session
        - Strictness: \(pact.rules.strictness.rawValue)
        
        **Today's Usage:**
        - Minutes used today: \(context.todayUsageMinutes) / \(pact.rules.dailyLimitMinutes)
        - Attempts today: \(context.recentAttempts)
        - Current time: \(String(format: "%02d:%02d", context.currentHour, context.currentMinute))
        
        **Your Role:**
        \(strictnessGuidance)
        
        **Decision Format:**
        Respond in EXACTLY this format:
        
        DECISION: [ALLOW/DENY/ASK]
        MINUTES: [number 1-15, only if ALLOW]
        MESSAGE: [Your supportive message explaining the decision]
        ALTERNATIVES: [Comma-separated alternatives, only if DENY]
        
        **Examples:**
        
        DECISION: ALLOW
        MINUTES: 10
        MESSAGE: That sounds productive! You have 10 minutes to reply to your friend. Keep it focused.
        
        DECISION: DENY
        MESSAGE: You've already used 28 of your 30 minutes today. You're so close to your goal - let's save it for tomorrow!
        ALTERNATIVES: Take a 5-minute walk, Message them on WhatsApp instead, Write in your journal
        
        DECISION: ASK
        MESSAGE: I want to understand better - are you messaging someone specific, or planning to scroll the feed?
        
        **Guidelines:**
        - Be supportive, never judgmental
        - Reference their motivation when relevant
        - Celebrate progress and streaks
        - For ALLOW: grant 5-15 minutes based on intent clarity and remaining budget
        - For DENY: be empathetic and suggest 2-3 concrete alternatives
        - For ASK: when intent is vague or seems like self-justification
        """
    }
    
    private func getStrictnessGuidance(_ strictness: PactRules.StrictnessLevel) -> String {
        switch strictness {
        case .gentle:
            return """
            Be understanding and give the benefit of the doubt. Allow most reasonable requests.
            Focus on building awareness rather than blocking access.
            """
        case .balanced:
            return """
            Balance accountability with flexibility. Allow clear, purposeful requests.
            Challenge vague or habitual-sounding intents. Be firm but supportive when denying.
            """
        case .strict:
            return """
            Hold them to high standards. Only allow very specific, necessary tasks.
            Challenge most requests. Be firm about protecting their time and goals.
            Encourage alternatives to app usage whenever possible.
            """
        }
    }
    
    private func buildUserPrompt(intent: String, appName: String, context: SessionContext) -> String {
        return """
        The user wants to open \(appName).
        
        Their stated intent: "\(intent)"
        
        Should you allow, deny, or ask for clarification? Consider their pact rules, current usage, and how this aligns with their goal.
        """
    }
    
    // MARK: - Response Parsing
    
    private func parseDecision(from response: String, context: SessionContext) -> GatekeeperDecision {
        let lines = response.components(separatedBy: .newlines)
        var decision: String?
        var minutes: Int?
        var message: String?
        var alternatives: [String] = []
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("DECISION:") {
                decision = trimmed
                    .replacingOccurrences(of: "DECISION:", with: "")
                    .trimmingCharacters(in: .whitespaces)
                    .uppercased()
            } else if trimmed.hasPrefix("MINUTES:") {
                let minutesStr = trimmed
                    .replacingOccurrences(of: "MINUTES:", with: "")
                    .trimmingCharacters(in: .whitespaces)
                minutes = Int(minutesStr)
            } else if trimmed.hasPrefix("MESSAGE:") {
                message = trimmed
                    .replacingOccurrences(of: "MESSAGE:", with: "")
                    .trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("ALTERNATIVES:") {
                let altsStr = trimmed
                    .replacingOccurrences(of: "ALTERNATIVES:", with: "")
                    .trimmingCharacters(in: .whitespaces)
                alternatives = altsStr
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            } else if !trimmed.isEmpty && message != nil {
                // Continuation of message
                message? += " " + trimmed
            }
        }
        
        // Parse decision
        switch decision {
        case "ALLOW":
            let grantedMinutes = min(minutes ?? context.pact.rules.sessionLimitMinutes, 
                                    context.pact.rules.sessionLimitMinutes)
            let finalMessage = message ?? "Access granted. Use it wisely!"
            return .allow(minutes: grantedMinutes, message: finalMessage)
            
        case "DENY":
            let finalMessage = message ?? "This doesn't align with your goals right now."
            return .deny(reason: finalMessage, alternatives: alternatives)
            
        case "ASK":
            let finalMessage = message ?? "Can you tell me more about what you're planning to do?"
            return .followUp(question: finalMessage)
            
        default:
            // Fallback: if we can't parse, default to deny with supportive message
            return .deny(
                reason: "I'm not sure this is the best use of your time right now.",
                alternatives: ["Take a short break", "Return to your current task"]
            )
        }
    }
}



