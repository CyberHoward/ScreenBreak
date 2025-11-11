import SwiftUI
import OpenAI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var isSending: Bool = false

    private let service: AIChatService

    // this is what we actually send to OpenAI
    private var chatHistory: [ChatQuery.ChatCompletionMessageParam] = []

    init(service: AIChatService = AIChatService()) {
        self.service = service

        // build initial system message SAFELY
        if let system = ChatQuery.ChatCompletionMessageParam(
            role: .system,
            content: "You are a helpful iOS assistant."
        ) {
            chatHistory.append(system)
        }
    }

    func sendMessage() {
        let text = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        // add user message to UI
        messages.append(.user(text))
        userInput = ""

        // add user message to history (unwrap again)
        if let userMsg = ChatQuery.ChatCompletionMessageParam(role: .user, content: text) {
            chatHistory.append(userMsg)
        }

        isSending = true

        Task {
            do {
                // create placeholder assistant message in UI
                let assistantIndex = messages.endIndex
                messages.append(.assistant(""))

                var accumulated = ""

                let stream = service.streamReply(messages: chatHistory)

                for try await chunk in stream {
                    accumulated += chunk
                    messages[assistantIndex] = .assistant(accumulated)
                }

                // once streaming is done, store assistant message in history
                if let assistantMsg = ChatQuery.ChatCompletionMessageParam(
                    role: .assistant,
                    content: accumulated
                ) {
                    chatHistory.append(assistantMsg)
                }
            } catch {
                messages.append(.system("⚠️ \(error.localizedDescription)"))
            }

            isSending = false
        }
    }
}

// simple model for the UI
enum ChatMessage: Identifiable {
    case user(String)
    case assistant(String)
    case system(String)

    var id: UUID { UUID() }

    var text: String {
        switch self {
        case .user(let t), .assistant(let t), .system(let t):
            return t
        }
    }
}
