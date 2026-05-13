import Foundation

struct Hospital: Identifiable, Codable {
    let id: UUID
    var name: String
    var shortName: String
    var address: String
    var latitude: Double
    var longitude: Double
    var contactNumber: String
    var isPartner: Bool
    var isVerified: Bool = true
    var licenseNumber: String = ""
    var partnershipSignedDate: Date? = nil

    func distance(fromLat lat: Double, fromLon lon: Double) -> Double {
        let earthRadius = 6371.0
        let dLat = (lat - latitude) * .pi / 180
        let dLon = (lon - longitude) * .pi / 180
        let a = sin(dLat / 2) * sin(dLat / 2) +
                 cos(latitude * .pi / 180) * cos(lat * .pi / 180) *
                 sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return earthRadius * c
    }
}
