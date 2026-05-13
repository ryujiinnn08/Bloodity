import Foundation

struct Donation: Identifiable, Codable {
    let id: UUID
    var donorId: UUID
    var recipientRequestId: UUID?
    var hospitalName: String
    var donationDate: Date
    var bloodType: BloodType
    var unitsDonated: Int

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: donationDate)
    }
}
