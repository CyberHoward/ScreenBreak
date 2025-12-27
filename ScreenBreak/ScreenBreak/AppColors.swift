//
//  AppColors.swift
//  ScreenBreak
//
//  Color system based on blueprints/05_color.md
//  Using OKLCH color space converted to sRGB for SwiftUI compatibility
//

import SwiftUI

// MARK: - App Color Theme

/// Centralized color definitions based on the app's design system.
/// Colors are defined in OKLCH and converted to sRGB for compatibility.
///
/// Light mode hue: 38 (warm terracotta/orange)
/// Dark mode: Same hue with adjusted lightness values
enum AppColors {
    
    // MARK: - Background Colors
    
    /// Darkest background - used for cards, elevated surfaces
    static var bgDark: Color {
        Color("bgDark")
    }
    
    /// Main background color
    static var bg: Color {
        Color("bg")
    }
    
    /// Lightest background - used for highlights, inputs
    static var bgLight: Color {
        Color("bgLight")
    }
    
    // MARK: - Text Colors
    
    /// Primary text color
    static var text: Color {
        Color("textPrimary")
    }
    
    /// Muted/secondary text color
    static var textMuted: Color {
        Color("textMuted")
    }
    
    // MARK: - UI Colors
    
    /// Highlight color for emphasis
    static var highlight: Color {
        Color("highlight")
    }
    
    /// Border color for prominent borders
    static var border: Color {
        Color("borderColor")
    }
    
    /// Muted border color for subtle borders
    static var borderMuted: Color {
        Color("borderMuted")
    }
    
    // MARK: - Semantic Colors
    
    /// Primary action color (warm terracotta)
    static var primary: Color {
        Color("primaryColor")
    }
    
    /// Secondary action color (cool blue)
    static var secondary: Color {
        Color("secondaryColor")
    }
    
    /// Danger/error states
    static var danger: Color {
        Color("dangerColor")
    }
    
    /// Warning states
    static var warning: Color {
        Color("warningColor")
    }
    
    /// Success states
    static var success: Color {
        Color("successColor")
    }
    
    /// Informational states
    static var info: Color {
        Color("infoColor")
    }
}

// MARK: - Color Extension for Convenience

extension Color {
    
    // MARK: - Background Shorthands
    
    /// App's main background
    static var appBackground: Color { AppColors.bg }
    
    /// Darker background for cards
    static var cardBackground: Color { AppColors.bgDark }
    
    /// Light background for inputs/highlights
    static var inputBackground: Color { AppColors.bgLight }
    
    // MARK: - Text Shorthands
    
    /// Primary text
    static var appText: Color { AppColors.text }
    
    /// Secondary/muted text
    static var appTextMuted: Color { AppColors.textMuted }
    
    // MARK: - Semantic Shorthands
    
    /// Primary action color
    static var appPrimary: Color { AppColors.primary }
    
    /// Secondary action color
    static var appSecondary: Color { AppColors.secondary }
    
    /// Danger color
    static var appDanger: Color { AppColors.danger }
    
    /// Warning color
    static var appWarning: Color { AppColors.warning }
    
    /// Success color
    static var appSuccess: Color { AppColors.success }
    
    /// Info color
    static var appInfo: Color { AppColors.info }
}

// MARK: - View Modifiers for Consistent Styling

extension View {
    /// Apply app's primary background
    func appBackgroundStyle() -> some View {
        self.background(AppColors.bg)
    }
    
    /// Apply card styling with elevated background
    func cardStyle() -> some View {
        self
            .background(AppColors.bgLight)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.borderMuted, lineWidth: 1)
            )
    }
    
    /// Apply primary button styling
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColors.primary)
            .cornerRadius(12)
    }
    
    /// Apply secondary button styling
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(AppColors.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColors.bgLight)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.border, lineWidth: 1.5)
            )
            .cornerRadius(12)
    }
}

