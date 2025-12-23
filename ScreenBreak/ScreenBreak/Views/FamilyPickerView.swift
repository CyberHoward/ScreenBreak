//
//  FamilyPickerView.swift
//  ScreenBreak
//
//  Created by Mya Mahaley on 4/11/23.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct FamilyPickerView: View {
    @ObservedObject var model: MyModel
    @Binding var isDiscouragedPresented: Bool

    @State private var noAppsAlert = false
    @State private var maxAppsAlert = false
    
    var body: some View {
        VStack {
            Text("Select Apps to Restrict")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Choose which apps you want to limit during restriction mode")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            FamilyActivityPicker(selection: $model.selectionToDiscourage)
                .padding()
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    isDiscouragedPresented = false
                }
                .foregroundColor(.secondary)
                
                Button("Save") {
                    if model.selectionToDiscourage.applicationTokens.count == 0 && model.selectionToDiscourage.categoryTokens.count == 0 {
                        noAppsAlert = true
                        maxAppsAlert = false
                    } else if model.selectionToDiscourage.applicationTokens.count >= 20 {
                        noAppsAlert = false
                        maxAppsAlert = true
                    } else {
                        isDiscouragedPresented = false
                    }
                }
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            }
            .padding(.bottom)
        }
        .background(Color("backgroundColor"))
        .alert("No Apps Selected", isPresented: $noAppsAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select at least one app or category to restrict.")
        }
        .alert("Too Many Apps", isPresented: $maxAppsAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select fewer than 20 apps for optimal performance.")
        }
    }
}
