import SwiftUI

@Observable
class DonorViewModel {
    var currentUser: User
    var nearbyRequests: [BloodRequest]
    var donationHistory: [Donation]
    var isAvailable: Bool

    init(user: User) {
        self.currentUser = user
        self.isAvailable = user.isAvailable
        self.donationHistory = MockData.donations

        // Filter requests compatible with donor's blood type
        self.nearbyRequests = MockData.bloodRequests.filter { request in
            request.isActive && request.bloodTypeNeeded.compatibleDonors.contains(user.bloodType)
        }
    }

    var activeRequestCount: Int {
        nearbyRequests.filter { $0.isActive }.count
    }

    var compatibleRequests: [BloodRequest] {
        nearbyRequests.sorted { $0.urgencyLevel == .critical && $1.urgencyLevel != .critical }
    }

    func toggleAvailability() {
        withAnimation(.spring(response: 0.4)) {
            isAvailable.toggle()
            currentUser.isAvailable = isAvailable
        }
    }

    func acceptRequest(_ request: BloodRequest) {
        if let index = nearbyRequests.firstIndex(where: { $0.id == request.id }) {
            withAnimation(.spring(response: 0.4)) {
                nearbyRequests[index].status = .donorFound
                nearbyRequests[index].matchedDonorId = currentUser.id
            }
        }
    }

    func declineRequest(_ request: BloodRequest) {
        if let index = nearbyRequests.firstIndex(where: { $0.id == request.id }) {
            withAnimation(.spring(response: 0.4)) {
                nearbyRequests.remove(at: index)
            }
        }
    }
}
