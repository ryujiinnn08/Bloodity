import SwiftUI

/// Shared, reactive data store seeded with MockData.
/// All ViewModels read/write from this single source of truth so that
/// mutations during a presentation are reflected everywhere instantly.
@Observable
class DataStore {

    // MARK: - Singleton
    static let shared = DataStore()

    // MARK: - Live Data
    var bloodRequests: [BloodRequest]
    var donors: [User]
    var donations: [Donation]
    var bloodStocks: [BloodStock]
    var donorNotifications: [AppNotification]
    var hospitalNotifications: [AppNotification]
    var hospitals: [Hospital]

    private init() {
        self.bloodRequests = MockData.bloodRequests
        self.donors = MockData.donors
        self.donations = MockData.donations
        self.bloodStocks = MockData.bloodStocks
        self.donorNotifications = MockData.donorNotifications
        self.hospitalNotifications = MockData.hospitalNotifications
        self.hospitals = MockData.hospitals
    }

    // MARK: - Blood Requests

    func addRequest(_ request: BloodRequest) {
        withAnimation(.spring(response: 0.5)) {
            bloodRequests.insert(request, at: 0)
        }

        // Auto-generate a notification for the hospital
        let notification = AppNotification(
            id: UUID(),
            title: "New Blood Request",
            message: "\(request.hospitalName) needs \(request.bloodTypeNeeded.rawValue) blood — \(request.urgencyLevel.rawValue) urgency. \(request.unitsNeeded) unit(s) for \(request.patientName).",
            type: .newRequest,
            isRead: false,
            timestamp: Date(),
            relatedRequestId: request.id
        )
        hospitalNotifications.insert(notification, at: 0)

        // Also notify compatible donors
        let donorNotif = AppNotification(
            id: UUID(),
            title: "\(request.urgencyLevel == .critical ? "🚨 Critical" : request.urgencyLevel == .urgent ? "Urgent" : "New"): \(request.bloodTypeNeeded.rawValue) Blood Needed",
            message: "\(request.hospitalName) needs \(request.bloodTypeNeeded.rawValue) blood. \(request.ward). Tap to respond.",
            type: .newRequest,
            isRead: false,
            timestamp: Date(),
            relatedRequestId: request.id
        )
        donorNotifications.insert(donorNotif, at: 0)
    }

    func updateRequestStatus(_ requestId: UUID, status: RequestStatus, donorId: UUID? = nil) {
        guard let index = bloodRequests.firstIndex(where: { $0.id == requestId }) else { return }
        withAnimation(.spring(response: 0.4)) {
            bloodRequests[index].status = status
            if let donorId { bloodRequests[index].matchedDonorId = donorId }
        }

        // Generate notification
        let request = bloodRequests[index]
        switch status {
        case .donorFound:
            let donorName = donors.first(where: { $0.id == donorId })?.name ?? "A donor"
            let notif = AppNotification(
                id: UUID(),
                title: "Donor Matched: \(request.patientName)",
                message: "\(donorName) (\(request.bloodTypeNeeded.rawValue)) accepted the request for \(request.patientName).",
                type: .donorFound,
                isRead: false,
                timestamp: Date(),
                relatedRequestId: request.id
            )
            hospitalNotifications.insert(notif, at: 0)
        case .fulfilled:
            let notif = AppNotification(
                id: UUID(),
                title: "Request Fulfilled",
                message: "Blood request for \(request.patientName) (\(request.bloodTypeNeeded.rawValue)) has been fulfilled.",
                type: .fulfilled,
                isRead: false,
                timestamp: Date(),
                relatedRequestId: request.id
            )
            hospitalNotifications.insert(notif, at: 0)
            donorNotifications.insert(AppNotification(
                id: UUID(),
                title: "Thank You for Donating!",
                message: "Your donation for \(request.patientName) at \(request.hospitalName) has been confirmed. You saved a life!",
                type: .fulfilled,
                isRead: false,
                timestamp: Date(),
                relatedRequestId: request.id
            ), at: 0)
        default:
            break
        }
    }

    func removeRequest(_ requestId: UUID) {
        withAnimation(.spring(response: 0.4)) {
            bloodRequests.removeAll { $0.id == requestId }
        }
    }

    // MARK: - Donations

    func addDonation(_ donation: Donation) {
        withAnimation(.spring(response: 0.4)) {
            donations.insert(donation, at: 0)
        }
    }

    // MARK: - Blood Stocks

    func updateStock(_ stockId: UUID, units: Int) {
        guard let index = bloodStocks.firstIndex(where: { $0.id == stockId }) else { return }
        withAnimation(.spring(response: 0.4)) {
            bloodStocks[index].unitsAvailable = units
        }
    }

    // MARK: - Donors

    func updateDonorAvailability(_ donorId: UUID, available: Bool) {
        guard let index = donors.firstIndex(where: { $0.id == donorId }) else { return }
        withAnimation(.spring(response: 0.4)) {
            donors[index].isAvailable = available
        }
    }

    // MARK: - Computed

    func activeRequests(compatibleWith bloodType: BloodType) -> [BloodRequest] {
        bloodRequests.filter { request in
            request.isActive && request.bloodTypeNeeded.compatibleDonors.contains(bloodType)
        }
    }

    var allActiveRequests: [BloodRequest] {
        bloodRequests.filter { $0.isActive }
    }

    var unreadDonorNotificationCount: Int {
        donorNotifications.filter { !$0.isRead }.count
    }

    var unreadHospitalNotificationCount: Int {
        hospitalNotifications.filter { !$0.isRead }.count
    }
}
