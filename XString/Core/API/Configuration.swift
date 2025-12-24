import Foundation

enum Configuration {
    static let groqAPIKey: String = {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "GROQ_API_KEY"
        ) as? String, !key.isEmpty else {
            fatalError("❌ GROQ_API_KEY missing from Info.plist")
        }
        return key
    }()
}

