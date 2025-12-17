//
//  ShieldConfigurationExtension.swift
//  shield
//
//  Configures the appearance of shields for blocked apps (Opal-style)
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Opal-style messaging: clear instruction for user
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemGray6,
            icon: UIImage(named: "sblogosmall.png"),
            title: ShieldConfiguration.Label(text: "This app is blocked", color: .label),
            subtitle: ShieldConfiguration.Label(
                text: "Open ScreenBreak to request access",
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: .systemBlue),
            primaryButtonBackgroundColor: .systemBackground,
            secondaryButtonLabel: nil
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Same configuration for category-based shielding
        return configuration(shielding: application)
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Similar configuration for web domains
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemGray6,
            title: ShieldConfiguration.Label(text: "This website is blocked", color: .label),
            subtitle: ShieldConfiguration.Label(
                text: "Open ScreenBreak to request access",
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: .systemBlue),
            primaryButtonBackgroundColor: .systemBackground,
            secondaryButtonLabel: nil
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return configuration(shielding: webDomain)
    }
}
