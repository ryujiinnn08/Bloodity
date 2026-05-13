import SwiftUI

@Observable
class HospitalViewModel {
    var currentUser: User
    var hospital: Hospital
    var selectedBloodTypeFilter: BloodType?
    let store = DataStore.shared

    init(user: User) {
        self.currentUser = user
        self.hospital = store.hospitals.first!
    }

    // MARK: - Computed (reads from DataStore)

    var bloodRequests: [BloodRequest] {
        store.bloodRequests
    }

    var donorPool: [User] {
        store.donors
    }

    var bloodStocks: [BloodStock] {
        store.bloodStocks
    }

    // MARK: - Dashboard Metrics
    var activeRequestCount: Int {
        store.bloodRequests.filter { $0.isActive }.count
    }

    var availableDonorCount: Int {
        store.donors.filter { $0.isAvailable && $0.isEligibleToDonate }.count
    }

    var totalUnitsInStock: Int {
        store.bloodStocks.reduce(0) { $0 + $1.unitsAvailable }
    }

    var fulfilledTodayCount: Int {
        store.bloodRequests.filter { $0.status == .fulfilled }.count
    }

    var activeRequests: [BloodRequest] {
        store.bloodRequests
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
            store.donors.filter { $0.bloodType == selectedBloodTypeFilter } :
            store.donors

        return donors.sorted { d1, d2 in
            let dist1 = d1.distance(to: hospital.latitude, hospital.longitude)
            let dist2 = d2.distance(to: hospital.latitude, hospital.longitude)
            return dist1 < dist2
        }
    }

    // MARK: - AI Predictions
    var criticalStocks: [BloodStock] {
        store.bloodStocks.filter { $0.severity == .critical }
    }

    var warningStocks: [BloodStock] {
        store.bloodStocks.filter { $0.severity == .warning }
    }

    var watchStocks: [BloodStock] {
        store.bloodStocks.filter { $0.severity == .watch }
    }

    var healthyStocks: [BloodStock] {
        store.bloodStocks.filter { $0.severity == nil }
    }

    // MARK: - Actions (write to DataStore)

    func notifyDonor(_ donor: User) {
        // Simulated notification
    }

    func approveRequest(_ request: BloodRequest) {
        store.updateRequestStatus(request.id, status: .donorFound)
    }

    // Requests where donor has arrived and is waiting for extraction
    var arrivedRequests: [BloodRequest] {
        store.bloodRequests.filter { $0.status == .donorArrived }
    }

    func completeTransfusion(_ request: BloodRequest) {
        // Mark as fulfilled — this triggers stock increment + notifications in DataStore
        store.updateRequestStatus(request.id, status: .fulfilled, donorId: request.matchedDonorId)

        // Set donor cooldown
        if let donorId = request.matchedDonorId,
           let donorIndex = store.donors.firstIndex(where: { $0.id == donorId }) {
            store.donors[donorIndex].lastDonationDate = Date()
            store.donors[donorIndex].totalDonations += 1
        }
    }
}
