import SwiftUI

@Observable
class HospitalViewModel {
    var currentUser: User
    var hospital: Hospital
    var bloodRequests: [BloodRequest]
    var donorPool: [User]
    var bloodStocks: [BloodStock]
    var selectedBloodTypeFilter: BloodType?

    init(user: User) {
        self.currentUser = user
        self.hospital = MockData.hospitals.first!
        self.bloodRequests = MockData.bloodRequests
        self.donorPool = MockData.donors
        self.bloodStocks = MockData.bloodStocks
    }

    // MARK: - Dashboard Metrics
    var activeRequestCount: Int {
        bloodRequests.filter { $0.isActive }.count
    }

    var availableDonorCount: Int {
        donorPool.filter { $0.isAvailable && $0.isEligibleToDonate }.count
    }

    var totalUnitsInStock: Int {
        bloodStocks.reduce(0) { $0 + $1.unitsAvailable }
    }

    var fulfilledTodayCount: Int {
        bloodRequests.filter { $0.status == .fulfilled }.count
    }

    var activeRequests: [BloodRequest] {
        bloodRequests
            .filter { $0.isActive }
            .sorted { req1, req2 in
                let order: [UrgencyLevel] = [.critical, .urgent, .standard]
                let i1 = order.firstIndex(of: req1.urgencyLevel) ?? 2
                let i2 = order.firstIndex(of: req2.urgencyLevel) ?? 2
                return i1 < i2
            }
    }

    // MARK: - Donor Pool
    var filteredDonors: [User] {
        let donors = selectedBloodTypeFilter != nil ?
            donorPool.filter { $0.bloodType == selectedBloodTypeFilter } :
            donorPool

        return donors.sorted { d1, d2 in
            let dist1 = d1.distance(to: hospital.latitude, hospital.longitude)
            let dist2 = d2.distance(to: hospital.latitude, hospital.longitude)
            return dist1 < dist2
        }
    }

    // MARK: - AI Predictions
    var criticalStocks: [BloodStock] {
        bloodStocks.filter { $0.severity == .critical }
    }

    var warningStocks: [BloodStock] {
        bloodStocks.filter { $0.severity == .warning }
    }

    var watchStocks: [BloodStock] {
        bloodStocks.filter { $0.severity == .watch }
    }

    var healthyStocks: [BloodStock] {
        bloodStocks.filter { $0.severity == nil }
    }

    // MARK: - Actions
    func notifyDonor(_ donor: User) {
        // Simulated notification
    }

    func approveRequest(_ request: BloodRequest) {
        if let index = bloodRequests.firstIndex(where: { $0.id == request.id }) {
            withAnimation(.spring(response: 0.4)) {
                bloodRequests[index].status = .donorFound
            }
        }
    }
}
