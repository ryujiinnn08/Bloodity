import SwiftUI

struct RequestCard: View {
    let request: BloodRequest
    var showActions: Bool = false
    var onViewDonors: (() -> Void)? = nil
    var onAccept: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            // Header
            HStack(alignment: .top) {
                BloodTypeBadge(bloodType: request.bloodTypeNeeded, size: .large)

                VStack(alignment: .leading, spacing: 2) {
                    Text(request.patientName)
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)

                    Text(request.hospitalName)
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    UrgencyChip(urgency: request.urgencyLevel)
                    Text(request.timeAgo)
                        .font(BFont.caption(11))
                        .foregroundColor(.textSecondary)
                }
            }

            // Details Row
            HStack(spacing: BSpacing.lg) {
                Label(request.ward, systemImage: "building.2.fill")
                Label("\(request.unitsNeeded) unit\(request.unitsNeeded > 1 ? "s" : "")", systemImage: "drop.fill")
                Spacer()
                StatusChip(status: request.status)
            }
            .font(BFont.caption())
            .foregroundColor(.textSecondary)

            // Actions
            if showActions {
                Divider()
                    .background(Color.white.opacity(0.1))

                HStack(spacing: BSpacing.md) {
                    if let onViewDonors = onViewDonors {
                        Button(action: onViewDonors) {
                            HStack(spacing: 4) {
                                Image(systemName: "person.2.fill")
                                Text("View Donors")
                            }
                            .font(BFont.captionBold())
                            .foregroundColor(.healBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.healBlue.opacity(0.15))
                            )
                        }
                    }

                    if let onAccept = onAccept {
                        Button(action: onAccept) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Accept")
                            }
                            .font(BFont.captionBold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(LinearGradient.bloodGradient)
                            )
                        }
                    }

                    Spacer()
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
        .overlay(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .stroke(
                    request.urgencyLevel == .critical ? Color.bloodRed.opacity(0.4) :
                    request.urgencyLevel == .urgent ? Color.warmAmber.opacity(0.3) :
                    Color.clear,
                    lineWidth: 1
                )
        )
    }
}

struct DonorCard: View {
    let donor: User
    let hospitalLat: Double
    let hospitalLon: Double
    var onNotify: (() -> Void)? = nil

    var distance: Double {
        donor.distance(to: hospitalLat, hospitalLon)
    }

    var body: some View {
        HStack(spacing: BSpacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(donor.bloodType.color.gradient)
                    .frame(width: 44, height: 44)

                Text(donor.name.prefix(1))
                    .font(BFont.headline())
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(donor.name)
                        .font(BFont.headline(15))
                        .foregroundColor(.textPrimary)

                    BloodTypeBadge(bloodType: donor.bloodType, size: .small)
                }

                HStack(spacing: BSpacing.sm) {
                    Label(String(format: "%.1f km", distance), systemImage: "location.fill")

                    if let lastDonation = donor.lastDonationDate {
                        Text("Last: \(formattedDate(lastDonation))")
                    }
                }
                .font(BFont.caption(11))
                .foregroundColor(.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                // Availability dot
                HStack(spacing: 4) {
                    Circle()
                        .fill(donor.isAvailable && donor.isEligibleToDonate ? Color.successGreen : Color.textSecondary)
                        .frame(width: 8, height: 8)
                    Text(donor.isAvailable && donor.isEligibleToDonate ? "Available" : "Unavailable")
                        .font(BFont.caption(11))
                        .foregroundColor(donor.isAvailable && donor.isEligibleToDonate ? .successGreen : .textSecondary)
                }

                if let onNotify = onNotify, donor.isAvailable && donor.isEligibleToDonate {
                    Button(action: onNotify) {
                        Text("Notify")
                            .font(BFont.captionBold(11))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(LinearGradient.bloodGradient))
                    }
                }
            }
        }
        .padding(BSpacing.md)
        .glassCard()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

#Preview {
    ZStack {
        Color.deepNavy.ignoresSafeArea()
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                RequestCard(
                    request: MockData.bloodRequests[0],
                    showActions: true,
                    onViewDonors: {},
                    onAccept: {}
                )
                DonorCard(
                    donor: MockData.donors[0],
                    hospitalLat: 14.5764,
                    hospitalLon: 120.9842,
                    onNotify: {}
                )
            }
            .padding()
        }
    }
}
