import Foundation

enum NotificationType: String, Codable {
    case newRequest = "New Request"
    case donorFound = "Donor Found"
    case fulfilled = "Fulfilled"
    case requestUpdate = "Request Update"
    case eligibilityRestored = "Eligibility Restored"
    case predictionAlert = "Prediction Alert"
    case systemAlert = "System Alert"

    var icon: String {
        switch self {
        case .newRequest: return "drop.fill"
        case .donorFound: return "person.fill.checkmark"
        case .fulfilled: return "checkmark.circle.fill"
        case .requestUpdate: return "exclamationmark.triangle.fill"
        case .eligibilityRestored: return "heart.circle.fill"
        case .predictionAlert: return "chart.line.uptrend.xyaxis"
        case .systemAlert: return "bell.fill"
        }
    }
}

struct AppNotification: Identifiable, Codable {
    let id: UUID
    var title: String
    var message: String
    var type: NotificationType
    var isRead: Bool
    var timestamp: Date
    var relatedRequestId: UUID?

    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)
        if interval < 60 { return "Just now" }
        if interval < 3600 { return "\(Int(interval / 60))m ago" }
        if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        return "\(Int(interval / 86400))d ago"
    }
}
