import SwiftUI

struct DonorRequestDetailView: View {
    let request: BloodRequest
    let donor: User
    var onAccept: () -> Void
    var onDecline: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isAccepting = false

    var distance: Double {
        donor.distance(to: MockData.hospitals.first(where: { $0.id == request.hospitalId })?.latitude ?? 14.5764,
                       MockData.hospitals.first(where: { $0.id == request.hospitalId })?.longitude ?? 120.9842)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: BSpacing.xxl) {
                        // Urgency Hero
                        urgencyHero

                        // Patient Info
                        patientInfoCard

                        // Hospital Info
                        hospitalInfoCard

                        // Distance & ETA
                        distanceCard

                        // Action Buttons
                        actionButtons
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Urgency Hero
    private var urgencyHero: some View {
        VStack(spacing: BSpacing.md) {
            ZStack {
                Circle()
                    .fill(request.urgencyLevel.color.opacity(0.15))
                    .frame(width: 80, height: 80)

                Image(systemName: request.urgencyLevel.icon)
                    .font(.system(size: 36))
                    .foregroundColor(request.urgencyLevel.color)
            }

            Text("\(request.urgencyLevel.rawValue) Blood Request")
                .font(BFont.title())
                .foregroundColor(.textPrimary)

            HStack(spacing: BSpacing.sm) {
                BloodTypeBadge(bloodType: request.bloodTypeNeeded, size: .large)
                Text("•")
                    .foregroundColor(.textSecondary)
                Text("\(request.unitsNeeded) unit\(request.unitsNeeded > 1 ? "s" : "") needed")
                    .font(BFont.body())
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, BSpacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: BRadius.xl)
                .fill(
                    LinearGradient(
                        colors: [request.urgencyLevel.color.opacity(0.15), Color.cardDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BRadius.xl)
                        .stroke(request.urgencyLevel.color.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Patient Info
    private var patientInfoCard: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Patient Information")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            infoRow(icon: "person.fill", label: "Patient", value: request.patientName)
            infoRow(icon: "drop.fill", label: "Blood Type", value: request.bloodTypeNeeded.rawValue)
            infoRow(icon: "clock.fill", label: "Requested", value: request.timeAgo)
            infoRow(icon: "number", label: "Units Needed", value: "\(request.unitsNeeded)")
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Hospital Info
    private var hospitalInfoCard: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Hospital")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            infoRow(icon: "building.2.fill", label: "Name", value: request.hospitalName)
            infoRow(icon: "mappin.circle.fill", label: "Ward", value: request.ward)

            if let hospital = MockData.hospitals.first(where: { $0.id == request.hospitalId }) {
                infoRow(icon: "map.fill", label: "Address", value: hospital.address)
                infoRow(icon: "phone.fill", label: "Contact", value: hospital.contactNumber)
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Distance Card
    private var distanceCard: some View {
        HStack(spacing: BSpacing.lg) {
            VStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.healBlue)
                Text(String(format: "%.1f km", distance))
                    .font(BFont.headline())
                    .foregroundColor(.textPrimary)
                Text("Distance")
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 50)
                .background(Color.white.opacity(0.1))

            VStack(spacing: 4) {
                Image(systemName: "car.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.warmAmber)
                Text("\(Int(distance * 3 + 5)) min")
                    .font(BFont.headline())
                    .foregroundColor(.textPrimary)
                Text("Est. Travel")
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 50)
                .background(Color.white.opacity(0.1))

            VStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.coralPink)
                Text(request.timeAgo)
                    .font(BFont.headline())
                    .foregroundColor(.textPrimary)
                Text("Posted")
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: BSpacing.md) {
            Button {
                isAccepting = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onAccept()
                }
            } label: {
                HStack {
                    if isAccepting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Accept & Navigate")
                    }
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!donor.isEligibleToDonate || isAccepting)

            Button {
                onDecline()
            } label: {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Decline")
                }
            }
            .buttonStyle(SecondaryButtonStyle())

            if !donor.isEligibleToDonate {
                Text("You are currently in your 56-day recovery period and cannot accept requests.")
                    .font(BFont.caption(11))
                    .foregroundColor(.warmAmber)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Helper
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: BSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .frame(width: 20)

            Text(label)
                .font(BFont.body())
                .foregroundColor(.textSecondary)

            Spacer()

            Text(value)
                .font(BFont.body())
                .foregroundColor(.textPrimary)
        }
    }
}

#Preview {
    DonorRequestDetailView(
        request: MockData.bloodRequests[0],
        donor: MockData.donorAccount,
        onAccept: {},
        onDecline: {}
    )
}
