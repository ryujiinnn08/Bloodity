import Foundation

struct BloodStock: Identifiable, Codable {
    let id: UUID
    var hospitalId: UUID
    var bloodType: BloodType
    var unitsAvailable: Int
    var lastUpdated: Date
    var predictedDaysUntilDepletion: Int
    var severity: PredictionSeverity?
    var dailyUsageRate: Double
    var weeklyForecast: [Int]

    var isLow: Bool {
        unitsAvailable < 10
    }

    var isCritical: Bool {
        unitsAvailable < 5 || predictedDaysUntilDepletion < 7
    }
}
