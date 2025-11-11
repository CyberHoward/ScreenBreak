import Foundation
import OpenAI

final class AIChatService {
    private let client: OpenAI

    init(apiKey: String? = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]) {
        let key = apiKey ?? ""
        self.client = OpenAI(apiToken: key)
    }

    /// Streams assistant text based on the full history you pass in.
    func streamReply(
        messages: [ChatQuery.ChatCompletionMessageParam]
    ) -> AsyncThrowingStream<String, Error> {
        let query = ChatQuery(
            messages: messages,
            model: "gpt-4o-mini",
            temperature: 0.7
        )

        let openAIStream = client.chatsStream(query: query)

        return AsyncThrowingStream<String, Error> { continuation in
            Task {
                do {
                    for try await partial in openAIStream {
                        if let delta = partial.choices.first?.delta?.content?.string {
                            continuation.yield(delta)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
