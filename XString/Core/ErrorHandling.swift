import SwiftUI

enum AppError: Error, LocalizedError {
    case network(URLError)
    case authentication(String)
    case configuration(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network Error: \(error.localizedDescription)"
        case .authentication(let message):
            return message
        case .configuration(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}