//
//  FamilyPickerView.swift
//  ScreenBreak
//
//  Created by Mya Mahaley on 4/11/23.
//
//  MINIMAL BUILD VERSION - FamilyControls features commented out

import SwiftUI
// import FamilyControls  // Commented out for minimal build

struct FamilyPickerView: View {
    // MINIMAL BUILD - Properties commented out
    // @ObservedObject var model: MyModel
    // @Binding var isDiscouragedPresented: Bool

    // @State private var noAppsAlert = false
    // @State private var maxAppsAlert = false
    var body: some View {
        // MINIMAL BUILD - Show placeholder
        VStack(spacing: 20) {
            Image(systemName: "apps.iphone")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Feature Disabled")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Family Picker requires FamilyControls\nRe-enable in the full build")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
