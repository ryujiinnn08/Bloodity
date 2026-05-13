import SwiftUI

struct RequestTrackerView: View {
    let request: BloodRequest
    @Environment(\.dismiss) private var dismiss

    private let steps: [(status: RequestStatus, label: String, description: String)] = [
        (.searching, "Searching", "Broadcasting to nearby donors..."),
        (.donorFound, "Donor Found", "A compatible donor has accepted"),
        (.onTheWay, "On the Way", "Donor is heading to the hospital"),
        (.fulfilled, "Fulfilled", "Blood has been received"),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: BSpacing.xxl) {
                        // Request Summary
                        requestSummary

                        // Progress Steps
                        progressTracker

                        // Matched Donor (if found)
                        if request.status == .donorFound || request.status == .onTheWay || request.status == .fulfilled {
                            matchedDonorCard
                        }

                        // Hospital Info
                        hospitalInfo
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Request Tracker")
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)
                }

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

    // MARK: - Request Summary
    private var requestSummary: some View {
        VStack(spacing: BSpacing.md) {
            HStack {
                BloodTypeBadge(bloodType: request.bloodTypeNeeded, size: .large)

                VStack(alignment: .leading, spacing: 2) {
                    Text(request.patientName)
                        .font(BFont.title(20))
                        .foregroundColor(.textPrimary)

                    Text(request.hospitalName)
                        .font(BFont.body())
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                UrgencyChip(urgency: request.urgencyLevel)
            }

            HStack {
                Label("\(request.unitsNeeded) unit\(request.unitsNeeded > 1 ? "s" : "")", systemImage: "drop.fill")
                Label(request.ward, systemImage: "building.2.fill")
                Spacer()
                Text(request.timeAgo)
            }
            .font(BFont.caption())
            .foregroundColor(.textSecondary)
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Progress Tracker
    private var progressTracker: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Request Status")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)
                .padding(.bottom, BSpacing.lg)

            ForEach(Array(steps.enumerated()), id: \.0) { index, step in
                HStack(alignment: .top, spacing: BSpacing.lg) {
                    // Step indicator
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(stepColor(for: step.status))
                                .frame(width: 32, height: 32)

                            if isStepCompleted(step.status) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            } else if isCurrentStep(step.status) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.surfaceDark)
                                    .frame(width: 10, height: 10)
                            }
                        }

                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(isStepCompleted(step.status) ? Color.successGreen : Color.surfaceDark)
                                .frame(width: 2, height: 40)
                        }
                    }

                    // Step content
                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.label)
                            .font(BFont.headline(15))
                            .foregroundColor(isStepCompleted(step.status) || isCurrentStep(step.status) ? .textPrimary : .textSecondary)

                        Text(step.description)
                            .font(BFont.caption())
                            .foregroundColor(.textSecondary)

                        if isCurrentStep(step.status) && step.status == .searching {
                            HStack(spacing: 6) {
                                ProgressView()
                                    .tint(.warmAmber)
                                    .scaleEffect(0.8)
                                Text("Searching within \(Int(request.radiusKm)) km radius...")
                                    .font(BFont.caption(11))
                                    .foregroundColor(.warmAmber)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.bottom, index < steps.count - 1 ? BSpacing.sm : 0)
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Matched Donor
    private var matchedDonorCard: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Matched Donor")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            if let donorId = request.matchedDonorId,
               let donor = MockData.donors.first(where: { $0.id == donorId }) {
                HStack(spacing: BSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(donor.bloodType.color.gradient)
                            .frame(width: 50, height: 50)

                        Text(donor.name.prefix(1))
                            .font(BFont.title())
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(donor.name)
                            .font(BFont.headline())
                            .foregroundColor(.textPrimary)

                        HStack(spacing: 6) {
                            BloodTypeBadge(bloodType: donor.bloodType, size: .small)
                            Text("•")
                                .foregroundColor(.textSecondary)
                            Text("\(donor.totalDonations) past donations")
                                .font(BFont.caption())
                                .foregroundColor(.textSecondary)
                        }
                    }

                    Spacer()

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.successGreen)
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Hospital Info
    private var hospitalInfo: some View {
        Group {
            if let hospital = MockData.hospitals.first(where: { $0.id == request.hospitalId }) {
                VStack(alignment: .leading, spacing: BSpacing.md) {
                    Text("Hospital Details")
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)

                    infoRow(icon: "building.2.fill", value: hospital.name)
                    infoRow(icon: "map.fill", value: hospital.address)
                    infoRow(icon: "phone.fill", value: hospital.contactNumber)
                }
                .padding(BSpacing.lg)
                .glassCard()
            }
        }
    }

    // MARK: - Helpers
    private func stepColor(for status: RequestStatus) -> Color {
        if isStepCompleted(status) { return .successGreen }
        if isCurrentStep(status) { return status.color }
        return .surfaceDark
    }

    private func isStepCompleted(_ stepStatus: RequestStatus) -> Bool {
        let order: [RequestStatus] = [.searching, .donorFound, .onTheWay, .fulfilled]
        guard let stepIndex = order.firstIndex(of: stepStatus),
              let currentIndex = order.firstIndex(of: request.status) else { return false }
        return stepIndex < currentIndex
    }

    private func isCurrentStep(_ stepStatus: RequestStatus) -> Bool {
        return stepStatus == request.status
    }

    private func infoRow(icon: String, value: String) -> some View {
        HStack(spacing: BSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .frame(width: 20)
            Text(value)
                .font(BFont.body())
                .foregroundColor(.textPrimary)
        }
    }
}

#Preview {
    RequestTrackerView(request: MockData.bloodRequests[1])
}
