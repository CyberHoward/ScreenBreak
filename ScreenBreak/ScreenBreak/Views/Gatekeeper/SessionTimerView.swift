//
//  SessionTimerView.swift
//  ScreenBreak
//
//  View showing active session timer
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct SessionTimerView: View {
    let session: Session
    @ObservedObject private var sessionMonitor = SessionMonitorService.shared
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    
    init(session: Session) {
        self.session = session
        _timeRemaining = State(initialValue: session.remainingMinutes)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // App info
            if let appToken = session.getApplicationToken() {
                VStack(spacing: 12) {
                    Label(appToken)
                        .labelStyle(.iconOnly)
                        .frame(width: 60, height: 60)
                    
                    Label(appToken)
                        .labelStyle(.titleOnly)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            
            // Timer display
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        timeRemaining <= 2 ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
                
                VStack(spacing: 4) {
                    Text("\(timeRemaining)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(timeRemaining <= 2 ? .red : .primary)
                    
                    Text("minutes left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Intent reminder
            VStack(spacing: 8) {
                Text("You said you wanted to:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\"\(session.intent)\"")
                    .font(.body)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Status message
            if timeRemaining <= 2 {
                Text("⏰ Time's almost up!")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var progress: CGFloat {
        let total = Double(session.timeAllowedMinutes)
        let remaining = Double(timeRemaining)
        return CGFloat(remaining / total)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Mini Timer Widget

struct MiniSessionTimerView: View {
    let session: Session
    @State private var timeRemaining: Int
    
    init(session: Session) {
        self.session = session
        _timeRemaining = State(initialValue: session.remainingMinutes)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let appToken = session.getApplicationToken() {
                Label(appToken)
                    .labelStyle(.iconOnly)
                    .frame(width: 30, height: 30)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Active session")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(timeRemaining) min left")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(timeRemaining <= 2 ? .red : .green)
            }
            
            Spacer()
            
            Circle()
                .fill(timeRemaining <= 2 ? Color.red : Color.green)
                .frame(width: 8, height: 8)
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.3))
        .cornerRadius(12)
    }
}

#Preview {
    SessionTimerView(
        session: Session(
            appTokenData: Data(),
            timeAllowedMinutes: 10,
            intent: "Reply to messages",
            aiDecision: "Access granted"
        )
    )
}


