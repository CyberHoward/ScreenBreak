//
//  MicroReflectionView.swift
//  ScreenBreak
//
//  Quick post-session reflection prompt
//

import SwiftUI

struct MicroReflectionView: View {
    let session: Session
    @Binding var isPresented: Bool
    
    @State private var usedAsIntended = true
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Icon
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Session Complete")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Quick reflection")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Question
                    VStack(spacing: 16) {
                        Text("Did you use this time as you intended?")
                            .font(.body)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            Button(action: { usedAsIntended = true }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .font(.title)
                                    Text("Yes")
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(usedAsIntended ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                                .foregroundColor(usedAsIntended ? .green : .secondary)
                                .cornerRadius(12)
                            }
                            
                            Button(action: { usedAsIntended = false }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .font(.title)
                                    Text("No")
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(!usedAsIntended ? Color.orange.opacity(0.2) : Color.gray.opacity(0.1))
                                .foregroundColor(!usedAsIntended ? .orange : .secondary)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Optional notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Any notes? (optional)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("What went well or what would you change?", text: $notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...4)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Done button
                    Button(action: {
                        saveReflection()
                        isPresented = false
                    }) {
                        Text("Done")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func saveReflection() {
        // Could save reflection data for insights
        // For now, just dismiss
    }
}

#Preview {
    MicroReflectionView(
        session: Session(
            appTokenData: Data(),
            timeAllowedMinutes: 10,
            intent: "Reply to messages",
            aiDecision: "Access granted"
        ),
        isPresented: .constant(true)
    )
}
