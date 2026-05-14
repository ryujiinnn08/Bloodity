import Foundation

struct BloodStock: Identifiable, Codable {
    let id: UUID
    var hospitalId: UUID
    var bloodType: BloodType
    var unitsAvailable: Int
    var lastUpdated: Date
    var dailyUsageRate: Double

    // MARK: - AI Predictions (computed from live data)

    var predictedDaysUntilDepletion: Int {
        guard dailyUsageRate > 0 else { return 999 }
        return max(0, Int(Double(unitsAvailable) / dailyUsageRate))
    }

    var severity: PredictionSeverity? {
        if predictedDaysUntilDepletion <= 7 { return .critical }
        if predictedDaysUntilDepletion <= 14 { return .warning }
        if predictedDaysUntilDepletion <= 21 { return .watch }
        return nil
    }

    var weeklyForecast: [Int] {
        (0...4).map { week in
            max(0, unitsAvailable - Int(dailyUsageRate * 7.0 * Double(week)))
        }
    }

    var isLow: Bool {
        unitsAvailable < 10
    }

    var isCritical: Bool {
        unitsAvailable < 5 || predictedDaysUntilDepletion < 7
    }
}
