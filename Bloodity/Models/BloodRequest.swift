import Foundation

struct BloodRequest: Identifiable, Codable {
    let id: UUID
    var patientName: String
    var bloodTypeNeeded: BloodType
    var urgencyLevel: UrgencyLevel
    var hospitalName: String
    var hospitalId: UUID
    var ward: String
    var status: RequestStatus
    var requestDate: Date
    var radiusKm: Double
    var matchedDonorId: UUID?
    var requesterUserId: UUID
    var unitsNeeded: Int

    var timeAgo: String {
        let interval = Date().timeIntervalSince(requestDate)
        if interval < 60 { return "Just now" }
        if interval < 3600 { return "\(Int(interval / 60))m ago" }
        if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        return "\(Int(interval / 86400))d ago"
    }

    var isActive: Bool {
        status == .searching || status == .donorFound || status == .onTheWay
    }
}
