//
//  ChatView.swift
//  ScreenBreak
//
//  Created by Robin Bisschop on 09/11/2025.
//


struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(viewModel.messages.enumerated()), id: \.offset) { index, msg in
                            bubble(for: msg)
                                .id(index)
                        }

                        if viewModel.isSending {
                            ProgressView()
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Type a message…", text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { viewModel.sendMessage() }

                Button {
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(viewModel.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSending)
            }
            .padding()
        }
    }

    @ViewBuilder
    private func bubble(for message: ChatMessage) -> some View {
        switch message {
        case .user(let text):
            Text(text)
                .padding()
                .background(Color.accentColor.opacity(0.2))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .trailing)

        case .assistant(let text):
            Text(text)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .leading)

        case .system(let text):
            Text(text)
                .font(.footnote)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}