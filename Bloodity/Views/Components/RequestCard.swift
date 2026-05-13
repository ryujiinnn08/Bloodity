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
    @Binding var isExpanded: Bool
    var onRequestDonation: (() -> Void)? = nil
    @State private var showCopiedConfirmation = false

    var distance: Double {
        donor.distance(to: hospitalLat, hospitalLon)
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Compact Header (always visible)
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
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
                        // Availability indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(donor.isAvailable && donor.isEligibleToDonate ? Color.successGreen : Color.textSecondary)
                                .frame(width: 8, height: 8)
                            Text(donor.isAvailable && donor.isEligibleToDonate ? "Available" : "Unavailable")
                                .font(BFont.caption(11))
                                .foregroundColor(donor.isAvailable && donor.isEligibleToDonate ? .successGreen : .textSecondary)
                        }

                        // Chevron
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(BSpacing.md)

            // MARK: - Expanded Detail Panel
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.black.opacity(0.06))
                        .padding(.horizontal, BSpacing.md)

                    VStack(spacing: BSpacing.lg) {
                        // Info Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: BSpacing.md) {
                            donorInfoItem(
                                icon: "phone.fill",
                                label: "Phone",
                                value: donor.phone,
                                color: .healBlue
                            )

                            donorInfoItem(
                                icon: "drop.fill",
                                label: "Blood Type",
                                value: donor.bloodType.rawValue,
                                color: donor.bloodType.color
                            )

                            donorInfoItem(
                                icon: "heart.fill",
                                label: "Total Donations",
                                value: "\(donor.totalDonations)",
                                color: .bloodRed
                            )

                            donorInfoItem(
                                icon: "calendar",
                                label: "Registered",
                                value: formattedFullDate(donor.registrationDate),
                                color: .warmAmber
                            )

                            donorInfoItem(
                                icon: "location.fill",
                                label: "Distance",
                                value: String(format: "%.1f km away", distance),
                                color: .healBlue
                            )

                            donorInfoItem(
                                icon: "clock.fill",
                                label: "Last Donation",
                                value: donor.lastDonationDate != nil ? formattedFullDate(donor.lastDonationDate!) : "Never",
                                color: .successGreen
                            )
                        }

                        // Eligibility Progress
                        eligibilitySection

                        // Action Buttons
                        actionButtons
                    }
                    .padding(BSpacing.md)
                    .padding(.top, BSpacing.sm)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .glassCard()
        .overlay(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .stroke(
                    isExpanded ? donor.bloodType.color.opacity(0.25) : Color.clear,
                    lineWidth: 1.5
                )
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
    }

    // MARK: - Info Item
    private func donorInfoItem(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: BSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: BRadius.sm)
                    .fill(color.opacity(0.1))
                    .frame(width: 32, height: 32)

                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(BFont.caption(10))
                    .foregroundColor(.textSecondary)

                Text(value)
                    .font(BFont.captionBold(12))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer(minLength: 0)
        }
    }

    // MARK: - Eligibility
    private var eligibilitySection: some View {
        VStack(alignment: .leading, spacing: BSpacing.sm) {
            HStack {
                Image(systemName: donor.isEligibleToDonate ? "checkmark.shield.fill" : "hourglass")
                    .foregroundColor(donor.isEligibleToDonate ? .successGreen : .warmAmber)
                    .font(.system(size: 14))

                Text(donor.isEligibleToDonate ? "Eligible to Donate" : "\(donor.daysUntilEligible) days until eligible")
                    .font(BFont.captionBold(13))
                    .foregroundColor(donor.isEligibleToDonate ? .successGreen : .warmAmber)

                Spacer()

                Text("\(Int(donor.eligibilityProgress * 100))%")
                    .font(BFont.captionBold(11))
                    .foregroundColor(.textSecondary)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.surfaceDark)
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            donor.isEligibleToDonate ?
                            Color.successGreen.gradient :
                            Color.warmAmber.gradient
                        )
                        .frame(width: geo.size.width * donor.eligibilityProgress, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(BSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: BRadius.md)
                .fill(Color.surfaceDark.opacity(0.5))
        )
    }

    // MARK: - Actions
    private var actionButtons: some View {
        HStack(spacing: BSpacing.sm) {
            if let onRequestDonation = onRequestDonation, donor.isAvailable && donor.isEligibleToDonate {
                Button(action: onRequestDonation) {
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 12))
                        Text("Request Donation")
                            .font(BFont.captionBold(13))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .fill(LinearGradient.bloodGradient)
                    )
                }
            }

            Button {
                let details = """
                \(donor.name)
                Blood Type: \(donor.bloodType.rawValue)
                Phone: \(donor.phone)
                Donations: \(donor.totalDonations)
                Distance: \(String(format: "%.1f km", distance))
                Status: \(donor.isAvailable && donor.isEligibleToDonate ? "Available" : "Unavailable")
                """
                UIPasteboard.general.string = details
                withAnimation(.spring(response: 0.3)) {
                    showCopiedConfirmation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { showCopiedConfirmation = false }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: showCopiedConfirmation ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 12))
                    Text(showCopiedConfirmation ? "Copied!" : "Copy Details")
                        .font(BFont.captionBold(13))
                }
                .foregroundColor(showCopiedConfirmation ? .successGreen : .healBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .fill(showCopiedConfirmation ? Color.successGreen.opacity(0.1) : Color.healBlue.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .stroke(showCopiedConfirmation ? Color.successGreen.opacity(0.3) : Color.healBlue.opacity(0.3), lineWidth: 1)
                )
            }

            if !(donor.isAvailable && donor.isEligibleToDonate) && onRequestDonation != nil {
                Text("Not available for donation")
                    .font(BFont.caption(12))
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .fill(Color.surfaceDark.opacity(0.5))
                    )
            }
        }
    }

    // MARK: - Formatters
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    private func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
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
                    isExpanded: .constant(true),
                    onRequestDonation: {}
                )
                DonorCard(
                    donor: MockData.donors[3],
                    hospitalLat: 14.5764,
                    hospitalLon: 120.9842,
                    isExpanded: .constant(false),
                    onRequestDonation: {}
                )
            }
            .padding()
        }
    }
}
