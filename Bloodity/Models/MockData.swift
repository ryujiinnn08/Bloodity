import Foundation

struct MockData {

    // MARK: - Hospitals
    static let hospitals: [Hospital] = [
        Hospital(
            id: UUID(uuidString: "A0000001-0000-0000-0000-000000000001")!,
            name: "Philippine General Hospital",
            shortName: "PGH",
            address: "Taft Ave, Ermita, Manila",
            latitude: 14.5764,
            longitude: 120.9842,
            contactNumber: "+63 2 8554 8400",
            isPartner: true
        ),
        Hospital(
            id: UUID(uuidString: "A0000002-0000-0000-0000-000000000002")!,
            name: "St. Luke's Medical Center - BGC",
            shortName: "St. Luke's BGC",
            address: "Rizal Drive, BGC, Taguig",
            latitude: 14.5547,
            longitude: 121.0509,
            contactNumber: "+63 2 8789 7700",
            isPartner: true
        ),
        Hospital(
            id: UUID(uuidString: "A0000003-0000-0000-0000-000000000003")!,
            name: "The Medical City",
            shortName: "TMC",
            address: "Ortigas Ave, Pasig City",
            latitude: 14.5873,
            longitude: 121.0615,
            contactNumber: "+63 2 8988 1000",
            isPartner: true
        ),
        Hospital(
            id: UUID(uuidString: "A0000004-0000-0000-0000-000000000004")!,
            name: "Makati Medical Center",
            shortName: "Makati Med",
            address: "Amorsolo St, Makati City",
            latitude: 14.5604,
            longitude: 121.0148,
            contactNumber: "+63 2 8888 8999",
            isPartner: true
        ),
        Hospital(
            id: UUID(uuidString: "A0000005-0000-0000-0000-000000000005")!,
            name: "East Avenue Medical Center",
            shortName: "EAMC",
            address: "East Avenue, Quezon City",
            latitude: 14.6422,
            longitude: 121.0451,
            contactNumber: "+63 2 8928 0611",
            isPartner: true
        ),
        Hospital(
            id: UUID(uuidString: "A0000006-0000-0000-0000-000000000006")!,
            name: "Philippine Red Cross",
            shortName: "Red Cross",
            address: "Bonifacio Drive, Port Area, Manila",
            latitude: 14.5895,
            longitude: 120.9721,
            contactNumber: "+63 2 8527 0000",
            isPartner: true
        ),
        Hospital(
            id: UUID(uuidString: "A0000007-0000-0000-0000-000000000007")!,
            name: "Ospital ng Maynila",
            shortName: "ONM",
            address: "Quiricada St, Santa Cruz, Manila",
            latitude: 14.6010,
            longitude: 120.9830,
            contactNumber: "+63 2 8711 2291",
            isPartner: false,
            isVerified: false
        ),
        Hospital(
            id: UUID(uuidString: "A0000008-0000-0000-0000-000000000008")!,
            name: "Cardinal Santos Medical Center",
            shortName: "CSMC",
            address: "Wilson St, San Juan City",
            latitude: 14.6020,
            longitude: 121.0350,
            contactNumber: "+63 2 8727 0001",
            isPartner: false,
            isVerified: false
        )
    ]

    // MARK: - Demo Accounts (Pre-created for judges)
    static let userAccount = User(
        id: UUID(uuidString: "D0000001-0000-0000-0000-000000000001")!,
        name: "Juan Dela Cruz",
        phone: "+63 917 123 4567",
        bloodType: .aPositive,
        role: .user,
        latitude: 14.5995,
        longitude: 120.9842,
        isAvailable: true,
        lastDonationDate: nil,
        registrationDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
        totalDonations: 3,
        profileImageName: nil
    )

    static let hospitalAccount = User(
        id: UUID(uuidString: "F0000001-0000-0000-0000-000000000001")!,
        name: "Dr. Elena Reyes",
        phone: "+63 919 555 0123",
        bloodType: .bPositive,
        role: .hospital,
        latitude: 14.5764,
        longitude: 120.9842,
        isAvailable: true,
        lastDonationDate: nil,
        registrationDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
        totalDonations: 0,
        profileImageName: nil
    )

    // MARK: - Donor Pool
    static let donors: [User] = [
        userAccount,
        User(id: UUID(uuidString: "D0000002-0000-0000-0000-000000000002")!, name: "Carlos Bautista", phone: "+63 920 111 2222", bloodType: .aPositive, role: .user, latitude: 14.6510, longitude: 121.0494, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -60, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -8, to: Date())!, totalDonations: 8, profileImageName: nil),
        User(id: UUID(uuidString: "D0000003-0000-0000-0000-000000000003")!, name: "Ana Liza Mercado", phone: "+63 921 333 4444", bloodType: .bNegative, role: .user, latitude: 14.5547, longitude: 121.0249, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -90, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -12, to: Date())!, totalDonations: 12, profileImageName: nil),
        User(id: UUID(uuidString: "D0000004-0000-0000-0000-000000000004")!, name: "Miguel Torres", phone: "+63 922 555 6666", bloodType: .oNegative, role: .user, latitude: 14.5873, longitude: 121.0615, isAvailable: false, lastDonationDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -4, to: Date())!, totalDonations: 3, profileImageName: nil),
        User(id: UUID(uuidString: "D0000005-0000-0000-0000-000000000005")!, name: "Sofia Ramos", phone: "+63 923 777 8888", bloodType: .abPositive, role: .user, latitude: 14.5604, longitude: 121.0148, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -70, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -10, to: Date())!, totalDonations: 7, profileImageName: nil),
        User(id: UUID(uuidString: "D0000006-0000-0000-0000-000000000006")!, name: "Rafael Garcia", phone: "+63 917 999 0000", bloodType: .aPositive, role: .user, latitude: 14.6200, longitude: 121.0300, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -120, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -14, to: Date())!, totalDonations: 15, profileImageName: nil),
        User(id: UUID(uuidString: "D0000007-0000-0000-0000-000000000007")!, name: "Isabella Cruz", phone: "+63 918 222 3333", bloodType: .bPositive, role: .user, latitude: 14.5300, longitude: 121.0000, isAvailable: true, lastDonationDate: nil, registrationDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, totalDonations: 0, profileImageName: nil),
        User(id: UUID(uuidString: "D0000008-0000-0000-0000-000000000008")!, name: "Diego Villanueva", phone: "+63 919 444 5555", bloodType: .oPositive, role: .user, latitude: 14.6100, longitude: 120.9900, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -58, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -5, to: Date())!, totalDonations: 4, profileImageName: nil),
        User(id: UUID(uuidString: "D0000009-0000-0000-0000-000000000009")!, name: "Camille Fernandez", phone: "+63 920 666 7777", bloodType: .aNegative, role: .user, latitude: 14.5700, longitude: 121.0300, isAvailable: false, lastDonationDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -3, to: Date())!, totalDonations: 2, profileImageName: nil),
        User(id: UUID(uuidString: "D0000010-0000-0000-0000-000000000010")!, name: "Marco Lim", phone: "+63 921 888 9999", bloodType: .abNegative, role: .user, latitude: 14.5500, longitude: 121.0600, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -100, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -9, to: Date())!, totalDonations: 6, profileImageName: nil),
        User(id: UUID(uuidString: "D0000011-0000-0000-0000-000000000011")!, name: "Patricia Mendoza", phone: "+63 922 111 0000", bloodType: .oPositive, role: .user, latitude: 14.6350, longitude: 121.0200, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -80, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -11, to: Date())!, totalDonations: 10, profileImageName: nil),
        User(id: UUID(uuidString: "D0000012-0000-0000-0000-000000000012")!, name: "Andres Reyes", phone: "+63 923 222 1111", bloodType: .bPositive, role: .user, latitude: 14.5800, longitude: 120.9700, isAvailable: true, lastDonationDate: Calendar.current.date(byAdding: .day, value: -65, to: Date()), registrationDate: Calendar.current.date(byAdding: .month, value: -7, to: Date())!, totalDonations: 9, profileImageName: nil),
    ]

    // MARK: - Blood Requests
    static let bloodRequests: [BloodRequest] = [
        BloodRequest(
            id: UUID(uuidString: "B0000001-0000-0000-0000-000000000001")!,
            patientName: "Pedro Alvarado",
            bloodTypeNeeded: .oPositive,
            urgencyLevel: .critical,
            hospitalName: "Philippine General Hospital",
            hospitalId: hospitals[0].id,
            ward: "Emergency Room",
            status: .searching,
            requestDate: Date().addingTimeInterval(-1800),
            radiusKm: 10,
            matchedDonorId: nil,
            requesterUserId: hospitalAccount.id,
            unitsNeeded: 3
        ),
        BloodRequest(
            id: UUID(uuidString: "B0000002-0000-0000-0000-000000000002")!,
            patientName: "Luisa Magtanggol",
            bloodTypeNeeded: .aPositive,
            urgencyLevel: .urgent,
            hospitalName: "St. Luke's Medical Center - BGC",
            hospitalId: hospitals[1].id,
            ward: "Surgery Ward B",
            status: .donorFound,
            requestDate: Date().addingTimeInterval(-7200),
            radiusKm: 15,
            matchedDonorId: donors[1].id,
            requesterUserId: hospitalAccount.id,
            unitsNeeded: 2
        ),
        BloodRequest(
            id: UUID(uuidString: "B0000003-0000-0000-0000-000000000003")!,
            patientName: "Ricardo Santos",
            bloodTypeNeeded: .bNegative,
            urgencyLevel: .standard,
            hospitalName: "The Medical City",
            hospitalId: hospitals[2].id,
            ward: "Hematology",
            status: .searching,
            requestDate: Date().addingTimeInterval(-3600),
            radiusKm: 20,
            matchedDonorId: nil,
            requesterUserId: hospitalAccount.id,
            unitsNeeded: 1
        ),
        BloodRequest(
            id: UUID(uuidString: "B0000004-0000-0000-0000-000000000004")!,
            patientName: "Teresa Villafuerte",
            bloodTypeNeeded: .abPositive,
            urgencyLevel: .critical,
            hospitalName: "Makati Medical Center",
            hospitalId: hospitals[3].id,
            ward: "ICU",
            status: .onTheWay,
            requestDate: Date().addingTimeInterval(-5400),
            radiusKm: 10,
            matchedDonorId: donors[4].id,
            requesterUserId: hospitalAccount.id,
            unitsNeeded: 4
        ),
        BloodRequest(
            id: UUID(uuidString: "B0000005-0000-0000-0000-000000000005")!,
            patientName: "Antonio Dela Peña",
            bloodTypeNeeded: .oNegative,
            urgencyLevel: .urgent,
            hospitalName: "East Avenue Medical Center",
            hospitalId: hospitals[4].id,
            ward: "Trauma Center",
            status: .searching,
            requestDate: Date().addingTimeInterval(-900),
            radiusKm: 25,
            matchedDonorId: nil,
            requesterUserId: hospitalAccount.id,
            unitsNeeded: 2
        ),
        BloodRequest(
            id: UUID(uuidString: "B0000006-0000-0000-0000-000000000006")!,
            patientName: "Margarita Lopez",
            bloodTypeNeeded: .aPositive,
            urgencyLevel: .standard,
            hospitalName: "Philippine General Hospital",
            hospitalId: hospitals[0].id,
            ward: "OB-GYN",
            status: .fulfilled,
            requestDate: Date().addingTimeInterval(-86400),
            radiusKm: 15,
            matchedDonorId: donors[5].id,
            requesterUserId: userAccount.id,
            unitsNeeded: 1
        ),
    ]

    // MARK: - Donation History
    static let donations: [Donation] = [
        Donation(id: UUID(), donorId: userAccount.id, recipientRequestId: nil, hospitalName: "Philippine General Hospital", donationDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())!, bloodType: .oPositive, unitsDonated: 1),
        Donation(id: UUID(), donorId: userAccount.id, recipientRequestId: nil, hospitalName: "St. Luke's Medical Center - BGC", donationDate: Calendar.current.date(byAdding: .day, value: -90, to: Date())!, bloodType: .oPositive, unitsDonated: 1),
        Donation(id: UUID(), donorId: userAccount.id, recipientRequestId: nil, hospitalName: "Makati Medical Center", donationDate: Calendar.current.date(byAdding: .day, value: -150, to: Date())!, bloodType: .oPositive, unitsDonated: 1),
        Donation(id: UUID(), donorId: userAccount.id, recipientRequestId: nil, hospitalName: "The Medical City", donationDate: Calendar.current.date(byAdding: .day, value: -210, to: Date())!, bloodType: .oPositive, unitsDonated: 1),
        Donation(id: UUID(), donorId: userAccount.id, recipientRequestId: nil, hospitalName: "East Avenue Medical Center", donationDate: Calendar.current.date(byAdding: .day, value: -270, to: Date())!, bloodType: .oPositive, unitsDonated: 1),
    ]

    // MARK: - Blood Stock (for PGH)
    static let bloodStocks: [BloodStock] = [
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .aPositive, unitsAvailable: 45, lastUpdated: Date(), dailyUsageRate: 2.1),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .aNegative, unitsAvailable: 8, lastUpdated: Date(), dailyUsageRate: 1.3),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .bPositive, unitsAvailable: 32, lastUpdated: Date(), dailyUsageRate: 1.8),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .bNegative, unitsAvailable: 5, lastUpdated: Date(), dailyUsageRate: 1.2),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .abPositive, unitsAvailable: 18, lastUpdated: Date(), dailyUsageRate: 1.2),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .abNegative, unitsAvailable: 3, lastUpdated: Date(), dailyUsageRate: 1.0),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .oPositive, unitsAvailable: 52, lastUpdated: Date(), dailyUsageRate: 2.6),
        BloodStock(id: UUID(), hospitalId: hospitals[0].id, bloodType: .oNegative, unitsAvailable: 12, lastUpdated: Date(), dailyUsageRate: 1.5),
    ]

    // MARK: - Notifications
    static let donorNotifications: [AppNotification] = [
        AppNotification(id: UUID(), title: "🚨 Critical: O+ Blood Needed", message: "Philippine General Hospital urgently needs O+ blood. You're 2.3 km away. Tap to respond.", type: .newRequest, isRead: false, timestamp: Date().addingTimeInterval(-1800), relatedRequestId: bloodRequests[0].id),
        AppNotification(id: UUID(), title: "Urgent: O- Blood Needed", message: "East Avenue Medical Center needs O- blood for a trauma case. 5.1 km from you.", type: .newRequest, isRead: false, timestamp: Date().addingTimeInterval(-900), relatedRequestId: bloodRequests[4].id),
        AppNotification(id: UUID(), title: "Thank You for Donating!", message: "Your donation at PGH on \(formattedDate(daysAgo: 30)) has been confirmed. You saved a life!", type: .fulfilled, isRead: true, timestamp: Calendar.current.date(byAdding: .day, value: -30, to: Date())!),
        AppNotification(id: UUID(), title: "26 Days Until Eligible", message: "Your 56-day rest period is ongoing. We'll notify you when you're eligible to donate again.", type: .systemAlert, isRead: true, timestamp: Calendar.current.date(byAdding: .day, value: -30, to: Date())!),
    ]

    static let hospitalNotifications: [AppNotification] = [
        AppNotification(id: UUID(), title: "⚠️ AI Alert: A- Stock Critical", message: "A- blood projected to deplete in 6 days. Sourcing cascade initiated — 3 compatible donors found nearby.", type: .predictionAlert, isRead: false, timestamp: Date().addingTimeInterval(-3600)),
        AppNotification(id: UUID(), title: "⚠️ AI Alert: B- Stock Critical", message: "B- blood projected to deplete in 4 days. Only 5 units remaining. Immediate action recommended.", type: .predictionAlert, isRead: false, timestamp: Date().addingTimeInterval(-7200)),
        AppNotification(id: UUID(), title: "Donor Matched: Pedro Alvarado", message: "Donor Juan Dela Cruz (O+) has been matched to patient Pedro Alvarado. ETA: 15 minutes.", type: .donorFound, isRead: true, timestamp: Date().addingTimeInterval(-1200)),
        AppNotification(id: UUID(), title: "Request Fulfilled", message: "Blood request for Margarita Lopez (A+) has been fulfilled. 1 unit delivered.", type: .fulfilled, isRead: true, timestamp: Date().addingTimeInterval(-86400)),
    ]

    // MARK: - Helper
    static func formattedDate(daysAgo: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
