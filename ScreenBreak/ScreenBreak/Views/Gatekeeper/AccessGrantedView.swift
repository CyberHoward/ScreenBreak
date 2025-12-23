//
//  AccessGrantedView.swift
//  ScreenBreak
//
//  View shown when AI grants access to an app
//

import SwiftUI

struct AccessGrantedView: View {
    let minutes: Int
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }
            
            // Title
            VStack(spacing: 12) {
                Text("Access Granted")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("You have \(minutes) minute\(minutes == 1 ? "" : "s")")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            
            // AI message
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // Action button
            Button(action: {
                isPresented = false
            }) {
                Text("Switch to App")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            
            Text("Your timer starts now")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
        }
        .background(Color("backgroundColor"))
    }
}

#Preview {
    AccessGrantedView(
        minutes: 10,
        message: "That sounds productive! Use it for what you said.",
        isPresented: .constant(true)
    )
}



