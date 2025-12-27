//
//  RequestAccessView.swift
//  ScreenBreak
//
//  Unified chat interface for requesting access to blocked apps
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct RequestAccessView: View {
    @StateObject private var chatViewModel = GatekeeperChatViewModel()
    @ObservedObject private var shieldService = ShieldManagementService.shared
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppColors.bg
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Blocked apps header (up to 4)
                    blockedAppsHeader
                    
                    // Chat messages
                    messagesScrollView
                    
                    // Decision result or input area
                    if let decision = chatViewModel.decision {
                        decisionResultView(decision)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        inputArea
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.bottom, 80) // Space for tab bar
            }
            .navigationTitle("Request Access")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Blocked Apps Header
    
    private var blockedAppsHeader: some View {
        VStack(spacing: 12) {
            if shieldService.shieldedApps.isEmpty {
                emptyAppsState
            } else {
                // Active sessions indicator
                if !shieldService.activeSessions.isEmpty {
                    activeSessionsBadge
                }
                
                // App chips
                blockedAppsChips
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            AppColors.bg
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private var emptyAppsState: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.shield.fill")
                .font(.title2)
                .foregroundColor(AppColors.success)
            
            Text("All apps accessible")
                .font(.subheadline)
                .foregroundColor(AppColors.textMuted)
        }
        .padding(.vertical, 8)
    }
    
    private var activeSessionsBadge: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(AppColors.success)
                .frame(width: 8, height: 8)
            
            Text("\(shieldService.activeSessions.count) active session\(shieldService.activeSessions.count == 1 ? "" : "s")")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppColors.success)
            
            Spacer()
        }
    }
    
    private var blockedAppsChips: some View {
        let selection = shieldService.shieldedApps.toFamilyActivitySelection()
        let tokens = Array(selection.applicationTokens.prefix(4))
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Select apps to request access")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !chatViewModel.selectedApps.isEmpty {
                    Text("\(chatViewModel.selectedApps.count) selected")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.secondary)
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(tokens, id: \.self) { token in
                    BlockedAppChip(
                        token: token,
                        isSelected: chatViewModel.isAppSelected(token),
                        onTap: {
                            withAnimation(.spring(response: 0.3)) {
                                chatViewModel.toggleAppSelection(token)
                            }
                        }
                    )
                }
            }
            
            if selection.applicationTokens.count > 4 {
                Text("+\(selection.applicationTokens.count - 4) more apps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Messages Scroll View
    
    private var messagesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Messages
                    ForEach(chatViewModel.messages) { message in
                        ChatMessageBubble(message: message)
                            .id(message.id)
                    }
                    
                    // Typing indicator
                    if chatViewModel.isProcessing {
                        AITypingIndicator()
                            .id("typing")
                    }
                    
                    Color.clear.frame(height: 20)
                        .id("bottom")
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .onChange(of: chatViewModel.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .onChange(of: chatViewModel.isProcessing) { _, isProcessing in
                if isProcessing {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo("typing", anchor: .bottom)
                    }
                }
            }
        }
    }
    
    // MARK: - Input Area
    
    private var inputArea: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Voice input button
                VoiceButton(
                    isRecording: $chatViewModel.isRecording,
                    onStartRecording: { chatViewModel.startRecording() },
                    onStopRecording: { chatViewModel.stopRecording() }
                )
                
                // Text field
                HStack {
                    TextField(
                        chatViewModel.selectedApps.isEmpty 
                            ? "Which app do you need and why?" 
                            : "Why do you need \(chatViewModel.selectedAppNames)?",
                        text: $chatViewModel.inputText, 
                        axis: .vertical
                    )
                        .textFieldStyle(.plain)
                        .lineLimit(1...4)
                        .focused($isTextFieldFocused)
                        .disabled(chatViewModel.isProcessing || chatViewModel.isRecording)
                    
                    if chatViewModel.isRecording {
                        RecordingWaveform()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                )
                
                // Send button
                Button(action: {
                    chatViewModel.sendMessage()
                    isTextFieldFocused = false
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            chatViewModel.canSend ? AppColors.primary : AppColors.textMuted.opacity(0.5)
                        )
                }
                .disabled(!chatViewModel.canSend)
                .animation(.easeInOut(duration: 0.2), value: chatViewModel.canSend)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }
    
    // MARK: - Decision Result View
    
    @ViewBuilder
    private func decisionResultView(_ decision: GatekeeperAIService.GatekeeperDecision) -> some View {
        VStack(spacing: 0) {
            Divider()
            
            switch decision {
            case .allow(let minutes, _):
                accessGrantedResult(minutes: minutes)
            case .deny(_, let alternatives):
                accessDeniedResult(alternatives: alternatives)
            case .followUp:
                inputArea
            }
        }
        .background(.ultraThinMaterial)
    }
    
    private func accessGrantedResult(minutes: Int) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.success)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Access Granted")
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                    
                    Text("\(minutes) minute\(minutes == 1 ? "" : "s") • \(chatViewModel.selectedApps.count) app\(chatViewModel.selectedApps.count == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textMuted)
                }
                
                Spacer()
            }
            
            Button(action: {
                // Reset for next request
                chatViewModel.reset()
            }) {
                HStack {
                    Text("Done")
                        .fontWeight(.semibold)
                    
                    Image(systemName: "checkmark")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.success)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding(16)
    }
    
    private func accessDeniedResult(alternatives: [String]) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.warning)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Not Right Now")
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                    
                    Text("Let's protect your focus")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textMuted)
                }
                
                Spacer()
            }
            
            if !alternatives.isEmpty {
                VStack(spacing: 8) {
                    Text("Try instead:")
                        .font(.caption)
                        .foregroundColor(AppColors.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(alternatives.prefix(3), id: \.self) { alt in
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.caption)
                                .foregroundColor(AppColors.secondary)
                            
                            Text(alt)
                                .font(.subheadline)
                                .foregroundColor(AppColors.text)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.bgLight)
                        .cornerRadius(8)
                    }
                }
            }
            
            Button(action: {
                chatViewModel.reset()
            }) {
                Text("Got It")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(16)
    }
}

// MARK: - Blocked App Chip

private struct AppChipIcon: View {
    let token: ApplicationToken
    
    var body: some View {
        Label(token)
            .labelStyle(.iconOnly)
            .frame(width: 28, height: 28)
    }
}

private struct AppChipTitle: View {
    let token: ApplicationToken
    
    var body: some View {
        Label(token)
            .labelStyle(.titleOnly)
            .font(.caption)
            .fontWeight(.medium)
            .lineLimit(1)
    }
}

struct BlockedAppChip: View {
    let token: ApplicationToken
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                AppChipIcon(token: token)
                
                AppChipTitle(token: token)
                    .foregroundColor(isSelected ? .white : AppColors.text)
                
                Spacer(minLength: 0)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primary : AppColors.bgLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primary : AppColors.borderMuted, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Chat Message Bubble

struct ChatMessageBubble: View {
    let message: GatekeeperChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.body)
                    .foregroundColor(message.isUser ? .white : AppColors.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        message.isUser
                            ? AnyShapeStyle(AppColors.primary)
                            : AnyShapeStyle(AppColors.bgLight)
                    )
                    .cornerRadius(18)
                    .cornerRadius(message.isUser ? 4 : 18, corners: message.isUser ? .bottomRight : .bottomLeft)
            }
            
            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
    }
}

// MARK: - AI Typing Indicator

struct AITypingIndicator: View {
    @State private var animationPhase = 0
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(AppColors.textMuted.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(animationPhase == index ? 1.2 : 1.0)
                        .opacity(animationPhase == index ? 1 : 0.5)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.bgLight)
            .cornerRadius(18)
            
            Spacer()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    animationPhase = (animationPhase + 1) % 3
                }
            }
        }
    }
}

// MARK: - Voice Button

struct VoiceButton: View {
    @Binding var isRecording: Bool
    let onStartRecording: () -> Void
    let onStopRecording: () -> Void
    
    var body: some View {
        Button(action: {
            if isRecording {
                onStopRecording()
            } else {
                onStartRecording()
            }
        }) {
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red : Color(.systemGray5))
                    .frame(width: 40, height: 40)
                
                if isRecording {
                    Circle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 52, height: 52)
                        .scaleEffect(isRecording ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isRecording)
                }
                
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isRecording ? .white : .primary)
            }
        }
        .animation(.spring(response: 0.3), value: isRecording)
    }
}

// MARK: - Recording Waveform

struct RecordingWaveform: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.red)
                    .frame(width: 3, height: isAnimating ? CGFloat.random(in: 12...20) : 8)
                    .animation(
                        .easeInOut(duration: 0.3)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RequestAccessView()
}
