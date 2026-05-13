import SwiftUI

@Observable
class RequesterViewModel {
    var currentUser: User
    var myRequests: [BloodRequest]
    var selectedHospital: Hospital?

    // New request form
    var newPatientName = ""
    var newBloodType: BloodType = .oPositive
    var newUrgency: UrgencyLevel = .urgent
    var newWard = ""
    var newUnits = 1
    var newRadius: Double = 15
    var isSubmitting = false

    init(user: User) {
        self.currentUser = user
        self.myRequests = MockData.bloodRequests
        self.selectedHospital = MockData.hospitals.first
    }

    var activeRequests: [BloodRequest] {
        myRequests.filter { $0.isActive }.sorted { $0.requestDate > $1.requestDate }
    }

    var completedRequests: [BloodRequest] {
        myRequests.filter { !$0.isActive }.sorted { $0.requestDate > $1.requestDate }
    }

    func submitRequest() {
        isSubmitting = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self, let hospital = self.selectedHospital else { return }

            let newRequest = BloodRequest(
                id: UUID(),
                patientName: self.newPatientName,
                bloodTypeNeeded: self.newBloodType,
                urgencyLevel: self.newUrgency,
                hospitalName: hospital.name,
                hospitalId: hospital.id,
                ward: self.newWard,
                status: .searching,
                requestDate: Date(),
                radiusKm: self.newRadius,
                matchedDonorId: nil,
                requesterUserId: self.currentUser.id,
                unitsNeeded: self.newUnits
            )

            withAnimation(.spring(response: 0.5)) {
                self.myRequests.insert(newRequest, at: 0)
                self.isSubmitting = false
            }

            // Reset form
            self.newPatientName = ""
            self.newWard = ""
            self.newUnits = 1
        }
    }
}
