import SwiftUI

@Observable
class DonorViewModel {
    var currentUser: User
    var isAvailable: Bool
    let store = DataStore.shared

    init(user: User) {
        self.currentUser = user
        self.isAvailable = user.isAvailable
    }

    // MARK: - Computed (reads from DataStore)

    var nearbyRequests: [BloodRequest] {
        store.activeRequests(compatibleWith: currentUser.bloodType)
    }

    var donationHistory: [Donation] {
        store.donations.filter { $0.donorId == currentUser.id }
    }

    var activeRequestCount: Int {
        nearbyRequests.count
    }

    var compatibleRequests: [BloodRequest] {
        nearbyRequests.sorted { $0.urgencyLevel == .critical && $1.urgencyLevel != .critical }
    }

    // MARK: - Actions (write to DataStore)

    func toggleAvailability() {
        withAnimation(.spring(response: 0.4)) {
            isAvailable.toggle()
            currentUser.isAvailable = isAvailable
            store.updateDonorAvailability(currentUser.id, available: isAvailable)
        }
    }

    func acceptRequest(_ request: BloodRequest) {
        store.updateRequestStatus(request.id, status: .donorFound, donorId: currentUser.id)

        // Record donation
        let donation = Donation(
            id: UUID(),
            donorId: currentUser.id,
            recipientRequestId: request.id,
            hospitalName: request.hospitalName,
            donationDate: Date(),
            bloodType: request.bloodTypeNeeded,
            unitsDonated: request.unitsNeeded
        )
        store.addDonation(donation)

        // Start cooldown — makes the user ineligible for 56 days
        currentUser.lastDonationDate = Date()
        currentUser.totalDonations += 1
    }

    func declineRequest(_ request: BloodRequest) {
        // Just hide it from this donor's view — don't delete the request
        // (Other donors can still see it)
    }
}
