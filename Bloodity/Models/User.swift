import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var phone: String
    var bloodType: BloodType
    var role: UserRole
    var latitude: Double
    var longitude: Double
    var isAvailable: Bool
    var lastDonationDate: Date?
    var registrationDate: Date
    var totalDonations: Int
    var profileImageName: String?

    var isEligibleToDonate: Bool {
        guard let lastDonation = lastDonationDate else { return true }
        let daysSinceLastDonation = Calendar.current.dateComponents([.day], from: lastDonation, to: Date()).day ?? 0
        return daysSinceLastDonation >= 56
    }

    var daysUntilEligible: Int {
        guard let lastDonation = lastDonationDate else { return 0 }
        let daysSinceLastDonation = Calendar.current.dateComponents([.day], from: lastDonation, to: Date()).day ?? 0
        return max(0, 56 - daysSinceLastDonation)
    }

    var eligibilityProgress: Double {
        guard let lastDonation = lastDonationDate else { return 1.0 }
        let daysSinceLastDonation = Calendar.current.dateComponents([.day], from: lastDonation, to: Date()).day ?? 0
        return min(1.0, Double(daysSinceLastDonation) / 56.0)
    }

    func distance(to otherLat: Double, _ otherLon: Double) -> Double {
        let earthRadius = 6371.0
        let dLat = (otherLat - latitude) * .pi / 180
        let dLon = (otherLon - longitude) * .pi / 180
        let a = sin(dLat / 2) * sin(dLat / 2) +
                 cos(latitude * .pi / 180) * cos(otherLat * .pi / 180) *
                 sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return earthRadius * c
    }
}
