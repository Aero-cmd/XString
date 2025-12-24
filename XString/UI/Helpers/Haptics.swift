//
//  Haptics.swift
//  XString
//
//  Created by AeroStar on 14/12/2025.
//

import UIKit
import CoreHaptics

enum Haptics {

    // MARK: - Existing UIKit haptics (unchanged)

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    // MARK: - Core Haptics (really long haptic)

    private static var engine: CHHapticEngine?

    static func long(
        duration: TimeInterval = 2.0,
        intensity: Float = 1.0,
        sharpness: Float = 0.5
    ) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            if engine == nil {
                engine = try CHHapticEngine()
                try engine?.start()
            }

            let intensityParam = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: intensity
            )

            let sharpnessParam = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: sharpness
            )

            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [intensityParam, sharpnessParam],
                relativeTime: 0,
                duration: duration
            )

            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)

            try player?.start(atTime: 0)

        } catch {
            print("Haptics.long error: \(error)")
        }
    }

    static func stopLong() {
        engine?.stop(completionHandler: nil)
        engine = nil
    }
}
