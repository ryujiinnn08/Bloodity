import SwiftUI

struct HospitalDashboard: View {
    @Bindable var viewModel: HospitalViewModel

    @State private var showDonorPool = false
    @State private var showAIPrediction = false
    @State private var showSmartFallback = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical) {
                    VStack(spacing: BSpacing.xl) {
                        // Header
                        headerSection

                        // Metrics Grid
                        metricsGrid

                        // AI Alert Banner (if any critical)
                        if !viewModel.criticalStocks.isEmpty {
                            aiAlertBanner
                        }

                        // Quick Actions
                        quickActions

                        // Active Transfusions (donors who arrived)
                        if !viewModel.arrivedRequests.isEmpty {
                            activeTransfusionsSection
                        }

                        // Active Requests
                        activeRequestsSection
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "cross.case.fill")
                            .foregroundColor(.healBlue)
                        Text(viewModel.hospital.shortName)
                            .font(BFont.headline())
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .navigationDestination(isPresented: $showDonorPool) {
                DonorPoolView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showAIPrediction) {
                AIPredictionView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showSmartFallback) {
                SmartFallbackView(viewModel: viewModel)
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome, \(viewModel.currentUser.name.components(separatedBy: " ").last ?? "Doctor")!")
                .font(BFont.title())
                .foregroundColor(.textPrimary)

            Text(viewModel.hospital.name)
                .font(BFont.body())
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, BSpacing.sm)
    }

    // MARK: - Metrics
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: BSpacing.md) {
            MetricCard(
                title: "Active Requests",
                value: "\(viewModel.activeRequestCount)",
                icon: "drop.fill",
                color: .bloodRed,
                trend: "+\(viewModel.activeRequestCount)"
            )

            MetricCard(
                title: "Available Donors",
                value: "\(viewModel.availableDonorCount)",
                icon: "person.2.fill",
                color: .successGreen
            )

            MetricCard(
                title: "Units in Stock",
                value: "\(viewModel.totalUnitsInStock)",
                icon: "cross.vial.fill",
                color: .healBlue
            )

            MetricCard(
                title: "Fulfilled Today",
                value: "\(viewModel.fulfilledTodayCount)",
                icon: "checkmark.circle.fill",
                color: .coralPink
            )
        }
    }

    // MARK: - AI Alert Banner
    private var aiAlertBanner: some View {
        Button {
            showAIPrediction = true
        } label: {
            HStack(spacing: BSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.bloodRed.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 20))
                        .foregroundColor(.bloodRed)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Alert: \(viewModel.criticalStocks.count) Blood Type\(viewModel.criticalStocks.count > 1 ? "s" : "") Critical")
                        .font(BFont.headline(14))
                        .foregroundColor(.white)

                    Text("\(viewModel.criticalStocks.map { $0.bloodType.rawValue }.joined(separator: ", ")) projected to deplete within 7 days")
                        .font(BFont.caption(12))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(BSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: BRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: [Color.bloodRed.opacity(0.8), Color.bloodRedDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .cardShadow()
        }
    }

    // MARK: - Quick Actions
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Quick Actions")
                .font(BFont.title(20))
                .foregroundColor(.textPrimary)

            HStack(spacing: BSpacing.md) {
                quickActionCard(
                    title: "Donor Pool",
                    icon: "person.2.fill",
                    color: .successGreen,
                    count: "\(viewModel.availableDonorCount)"
                ) {
                    showDonorPool = true
                }

                quickActionCard(
                    title: "AI Forecast",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .healBlue,
                    count: "\(viewModel.criticalStocks.count) alerts"
                ) {
                    showAIPrediction = true
                }

                quickActionCard(
                    title: "Sourcing",
                    icon: "arrow.triangle.branch",
                    color: .warmAmber,
                    count: "\(MockData.hospitals.filter { $0.isPartner }.count) partners"
                ) {
                    showSmartFallback = true
                }
            }
        }
    }

    private func quickActionCard(title: String, icon: String, color: Color, count: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: BSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.sm)
                            .fill(color.opacity(0.15))
                    )

                Text(title)
                    .font(BFont.captionBold())
                    .foregroundColor(.textPrimary)

                Text(count)
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, BSpacing.lg)
            .glassCard()
        }
    }

    // MARK: - Active Transfusions (Donor Arrived)
    private var activeTransfusionsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                HStack(spacing: BSpacing.sm) {
                    Image(systemName: "syringe.fill")
                        .foregroundColor(.successGreen)
                    Text("Active Transfusions")
                        .font(BFont.title(20))
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                Text("\(viewModel.arrivedRequests.count) awaiting")
                    .font(BFont.caption())
                    .foregroundColor(.warmAmber)
            }

            ForEach(viewModel.arrivedRequests) { request in
                transfusionCard(request)
            }
        }
    }

    @State private var completingRequestId: UUID?
    @State private var rejectingRequestId: UUID?

    private func transfusionCard(_ request: BloodRequest) -> some View {
        let donorName = DataStore.shared.donors.first(where: { $0.id == request.matchedDonorId })?.name ?? "Unknown Donor"

        return VStack(spacing: BSpacing.md) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.successGreen.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: "person.fill.checkmark")
                        .font(.system(size: 16))
                        .foregroundColor(.successGreen)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(donorName)
                        .font(BFont.headline(15))
                        .foregroundColor(.textPrimary)
                    Text("Arrived • Awaiting Extraction")
                        .font(BFont.caption(12))
                        .foregroundColor(.successGreen)
                }

                Spacer()

                BloodTypeBadge(bloodType: request.bloodTypeNeeded, size: .small)
            }

            // Patient info
            HStack(spacing: BSpacing.lg) {
                Label(request.patientName, systemImage: "person.fill")
                    .font(BFont.caption(12))
                    .foregroundColor(.textSecondary)

                Label(request.ward, systemImage: "building.2.fill")
                    .font(BFont.caption(12))
                    .foregroundColor(.textSecondary)

                Spacer()

                Text("\(request.unitsNeeded) unit\(request.unitsNeeded > 1 ? "s" : "")")
                    .font(BFont.captionBold(12))
                    .foregroundColor(.textPrimary)
            }

            // Action buttons
            HStack(spacing: BSpacing.md) {
                // Reject button
                Button {
                    rejectingRequestId = request.id
                } label: {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Reject")
                    }
                    .font(BFont.headline(14))
                    .foregroundColor(.bloodRed)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .stroke(Color.bloodRed, lineWidth: 1.5)
                    )
                }
                .alert("Reject Donor?", isPresented: Binding(
                    get: { rejectingRequestId == request.id },
                    set: { if !$0 { rejectingRequestId = nil } }
                )) {
                    Button("Cancel", role: .cancel) { rejectingRequestId = nil }
                    Button("Reject", role: .destructive) {
                        withAnimation(.spring(response: 0.4)) {
                            viewModel.rejectTransfusion(request)
                            rejectingRequestId = nil
                        }
                    }
                } message: {
                    Text("The donor will be notified and the request will return to searching status.")
                }

                // Complete button
                Button {
                    completingRequestId = request.id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(response: 0.4)) {
                            viewModel.completeTransfusion(request)
                            completingRequestId = nil
                        }
                    }
                } label: {
                    HStack {
                        if completingRequestId == request.id {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Complete")
                        }
                    }
                    .font(BFont.headline(14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .fill(Color.successGreen)
                    )
                }
                .disabled(completingRequestId == request.id)
            }
        }
        .padding(BSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .fill(Color.surfaceDark)
        )
        .overlay(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .stroke(Color.successGreen.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Active Requests
    private var activeRequestsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Text("Active Requests")
                    .font(BFont.title(20))
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(viewModel.activeRequests.count) pending")
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }

            if viewModel.activeRequests.isEmpty {
                VStack(spacing: BSpacing.md) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.successGreen.opacity(0.5))
                    Text("All requests fulfilled")
                        .font(BFont.body())
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, BSpacing.xxxl)
            } else {
                ForEach(viewModel.activeRequests) { request in
                    RequestCard(
                        request: request,
                        showActions: true,
                        onViewDonors: {
                            showDonorPool = true
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    HospitalDashboard(viewModel: HospitalViewModel(user: MockData.hospitalAccount))
}
