import SwiftUI

struct UserDashboard: View {
    @Bindable var donorVM: DonorViewModel
    @Bindable var requesterVM: RequesterViewModel

    @State private var selectedMode: DashboardMode = .donor
    @State private var showRequestDetail: BloodRequest?
    @State private var showNewRequest = false

    enum DashboardMode: String, CaseIterable {
        case donor = "Donor"
        case recipient = "Recipient"
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    // Red Header
                    headerSection

                    // Segmented Control
                    segmentedControl
                        .padding(.horizontal)
                        .padding(.top, BSpacing.lg)

                    // Content based on mode
                    Group {
                        switch selectedMode {
                        case .donor:
                            donorContent
                        case .recipient:
                            recipientContent
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, BSpacing.lg)
                    .padding(.bottom, 100)
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.deepNavy)
            .ignoresSafeArea(edges: .top)
            .sheet(item: $showRequestDetail) { request in
                DonorRequestDetailView(
                    request: request,
                    donor: donorVM.currentUser,
                    onAccept: {
                        donorVM.acceptRequest(request)
                        showRequestDetail = nil
                    },
                    onDecline: {
                        donorVM.declineRequest(request)
                        showRequestDetail = nil
                    }
                )
            }
            .sheet(isPresented: $showNewRequest) {
                NewRequestView(viewModel: requesterVM, isPresented: $showNewRequest)
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Background gradient
            LinearGradient.headerGradient
                .frame(height: 180)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("BLOODITY")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(2)

                    Text("Hello, \(donorVM.currentUser.name.components(separatedBy: " ").first ?? "User")!")
                        .font(BFont.title(24))
                        .foregroundColor(.white)

                    // Blood type badge
                    HStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 10))
                        Text(donorVM.currentUser.bloodType.rawValue)
                            .font(BFont.captionBold(12))
                        Text("Your Blood Type")
                            .font(BFont.caption(11))
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                    )
                }

                Spacer()

                // Profile circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Text(String(donorVM.currentUser.name.prefix(1)))
                        .font(BFont.title())
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, BSpacing.lg)
        }
    }

    // MARK: - Segmented Control
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(DashboardMode.allCases, id: \.rawValue) { mode in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedMode = mode
                    }
                } label: {
                    Text(mode.rawValue)
                        .font(BFont.headline(15))
                        .foregroundColor(selectedMode == mode ? .white : .textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            Group {
                                if selectedMode == mode {
                                    RoundedRectangle(cornerRadius: BRadius.sm)
                                        .fill(Color.bloodRed)
                                }
                            }
                        )
                }
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: BRadius.md)
                .fill(Color.surfaceDark)
        )
    }

    // MARK: - Donor Content
    private var donorContent: some View {
        VStack(spacing: BSpacing.lg) {
            // Availability Toggle
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Donor Availability")
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)
                    Text("Toggle to receive donation calls")
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary)

                    if donorVM.isAvailable {
                        HStack(spacing: 4) {
                            PulsingDot(color: .successGreen)
                            Text("Available to donate")
                                .font(BFont.caption(11))
                                .foregroundColor(.successGreen)
                        }
                    }
                }

                Spacer()

                Toggle("", isOn: Binding(
                    get: { donorVM.isAvailable },
                    set: { _ in donorVM.toggleAvailability() }
                ))
                .tint(.successGreen)
            }
            .padding(BSpacing.lg)
            .glassCard()

            // Nearby Requests
            if !donorVM.compatibleRequests.isEmpty {
                VStack(alignment: .leading, spacing: BSpacing.md) {
                    Text("HOSPITAL REQUESTS NEAR YOU")
                        .font(BFont.captionBold(12))
                        .foregroundColor(.textSecondary)
                        .tracking(0.5)

                    ForEach(donorVM.compatibleRequests) { request in
                        requestCard(request)
                    }
                }
            }

            // Donation Stats
            VStack(alignment: .leading, spacing: BSpacing.md) {
                Text("YOUR DONATION STATS")
                    .font(BFont.captionBold(12))
                    .foregroundColor(.textSecondary)
                    .tracking(0.5)

                HStack(spacing: 0) {
                    statColumn(
                        value: "\(donorVM.currentUser.totalDonations)",
                        label: "DONATIONS",
                        color: .textPrimary
                    )

                    Divider().frame(height: 40)

                    statColumn(
                        value: donorVM.currentUser.bloodType.rawValue,
                        label: "BLOOD TYPE",
                        color: .bloodRed
                    )

                    Divider().frame(height: 40)

                    statColumn(
                        value: donorVM.currentUser.isEligibleToDonate ? "Ready" : "\(donorVM.currentUser.daysUntilEligible)d",
                        label: "NEXT ELIGIBLE",
                        color: donorVM.currentUser.isEligibleToDonate ? .successGreen : .warmAmber
                    )
                }
                .padding(.vertical, BSpacing.lg)
                .glassCard()
            }
        }
    }

    // MARK: - Recipient Content
    private var recipientContent: some View {
        VStack(spacing: BSpacing.lg) {
            // New Request CTA
            Button {
                showNewRequest = true
            } label: {
                HStack(spacing: BSpacing.md) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Request Blood")
                            .font(BFont.headline())
                        Text("Submit a new blood request")
                            .font(BFont.caption())
                            .opacity(0.8)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .padding(BSpacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: BRadius.lg)
                        .fill(Color.bloodRed)
                )
                .cardShadow()
            }

            // Active Requests
            if !requesterVM.activeRequests.isEmpty {
                VStack(alignment: .leading, spacing: BSpacing.md) {
                    Text("ACTIVE REQUESTS")
                        .font(BFont.captionBold(12))
                        .foregroundColor(.textSecondary)
                        .tracking(0.5)

                    ForEach(requesterVM.activeRequests) { request in
                        RequestCard(request: request)
                    }
                }
            }

            // Completed
            if !requesterVM.completedRequests.isEmpty {
                VStack(alignment: .leading, spacing: BSpacing.md) {
                    Text("PAST REQUESTS")
                        .font(BFont.captionBold(12))
                        .foregroundColor(.textSecondary)
                        .tracking(0.5)

                    ForEach(requesterVM.completedRequests) { request in
                        RequestCard(request: request)
                            .opacity(0.7)
                    }
                }
            }
        }
    }

    // MARK: - Request Card (Donor View)
    private func requestCard(_ request: BloodRequest) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(request.hospitalName)
                        .font(BFont.headline(15))
                        .foregroundColor(.textPrimary)

                    Text("\(request.ward)  •  \(String(format: "%.1f km", donorVM.currentUser.distance(to: MockData.hospitals.first(where: { $0.id == request.hospitalId })?.latitude ?? 14.5764, MockData.hospitals.first(where: { $0.id == request.hospitalId })?.longitude ?? 120.9842)))")
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Text(request.bloodTypeNeeded.rawValue)
                    .font(BFont.title(20))
                    .foregroundColor(.bloodRed)
                    .fontWeight(.bold)
            }

            HStack(spacing: BSpacing.sm) {
                UrgencyChip(urgency: request.urgencyLevel)
                Text("\(request.unitsNeeded) bag\(request.unitsNeeded > 1 ? "s" : "")")
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
                Text("•")
                    .foregroundColor(.textSecondary)
                Text(request.timeAgo)
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
            }

            // Accept / Decline buttons
            HStack(spacing: BSpacing.md) {
                Button {
                    donorVM.declineRequest(request)
                } label: {
                    Text("Decline")
                        .font(BFont.captionBold())
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.sm)
                                .stroke(Color.textSecondary.opacity(0.3), lineWidth: 1)
                        )
                }

                Button {
                    showRequestDetail = request
                } label: {
                    Text("Accept")
                        .font(BFont.captionBold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.sm)
                                .fill(Color.bloodRed)
                        )
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
        .overlay(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .stroke(
                    request.urgencyLevel == .critical ? Color.bloodRed.opacity(0.4) : Color.clear,
                    lineWidth: 1
                )
        )
    }

    // MARK: - Helpers
    private func statColumn(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(BFont.metric(22))
                .foregroundColor(color)
            Text(label)
                .font(BFont.caption(10))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    UserDashboard(
        donorVM: DonorViewModel(user: MockData.userAccount),
        requesterVM: RequesterViewModel(user: MockData.userAccount)
    )
}
