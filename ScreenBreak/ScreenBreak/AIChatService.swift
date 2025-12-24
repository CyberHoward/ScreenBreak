import Foundation
import OpenAI

final class AIChatService {
    private let client: OpenAI
    private let hasValidKey: Bool

    init(apiKey: String? = nil) {
        // Try to get API key from multiple sources:
        // 1. Passed directly
        // 2. Environment variable
        // 3. Info.plist (for development)
        let key: String
        if let providedKey = apiKey, !providedKey.isEmpty {
            key = providedKey
        } else if let envKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !envKey.isEmpty {
            key = envKey
        } else if let plistKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String, !plistKey.isEmpty {
            key = plistKey
        } else {
            key = ""
            print("⚠️ AIChatService: No OpenAI API key found. Set OPENAI_API_KEY in environment or Info.plist")
        }
        
        self.hasValidKey = !key.isEmpty
        self.client = OpenAI(apiToken: key)
    }
    
    /// Check if the service has a valid API key configured
    var isConfigured: Bool {
        hasValidKey
    }

    /// Streams assistant text based on the full history you pass in.
    func streamReply(
        messages: [ChatQuery.ChatCompletionMessageParam]
    ) -> AsyncThrowingStream<String, Error> {
        // Check if API key is configured before making the request
        guard hasValidKey else {
            return AsyncThrowingStream<String, Error> { continuation in
                continuation.finish(throwing: AIChatError.missingAPIKey)
            }
        }
        
        let query = ChatQuery(
            messages: messages,
            model: "gpt-4o-mini",
            temperature: 0.7
        )

        let openAIStream: AsyncThrowingStream<ChatStreamResult, Error> = client.chatsStream(query: query)

        return AsyncThrowingStream<String, Error> { continuation in
            Task {
                do {
                    for try await partial in openAIStream {
                        if let delta = partial.choices.first?.delta.content {
                            continuation.yield(delta)
                        }
                    }
                    continuation.finish()
                } catch {
                    print("⚠️ AIChatService streaming error: \(error)")
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

// MARK: - Errors

enum AIChatError: LocalizedError {
    case missingAPIKey
    case networkError(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key not configured. Please add OPENAI_API_KEY to your environment or Info.plist."
        case .networkError(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        }
    }
}
