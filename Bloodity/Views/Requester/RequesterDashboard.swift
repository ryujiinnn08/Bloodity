import SwiftUI

struct RequesterDashboard: View {
    @Bindable var viewModel: RequesterViewModel
    @State private var showNewRequest = false
    @State private var selectedRequest: BloodRequest?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: BSpacing.xl) {
                        // Header
                        headerSection

                        // Quick Stats
                        statsRow

                        // New Request CTA
                        newRequestButton

                        // Active Requests
                        if !viewModel.activeRequests.isEmpty {
                            activeRequestsSection
                        }

                        // Completed Requests
                        if !viewModel.completedRequests.isEmpty {
                            completedRequestsSection
                        }
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
                        Image(systemName: "drop.fill")
                            .foregroundColor(.bloodRed)
                        Text("Bloodity")
                            .font(BFont.headline())
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showNewRequest) {
                NewRequestView(viewModel: viewModel, isPresented: $showNewRequest)
            }
            .sheet(item: $selectedRequest) { request in
                RequestTrackerView(request: request)
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hello, \(viewModel.currentUser.name.components(separatedBy: " ").first ?? "")!")
                .font(BFont.title())
                .foregroundColor(.textPrimary)

            Text("Manage your blood requests")
                .font(BFont.body())
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, BSpacing.sm)
    }

    // MARK: - Stats
    private var statsRow: some View {
        HStack(spacing: BSpacing.md) {
            MetricCard(
                title: "Active",
                value: "\(viewModel.activeRequests.count)",
                icon: "bolt.fill",
                color: .warmAmber
            )

            MetricCard(
                title: "Fulfilled",
                value: "\(viewModel.completedRequests.filter { $0.status == .fulfilled }.count)",
                icon: "checkmark.circle.fill",
                color: .successGreen
            )
        }
    }

    // MARK: - New Request CTA
    private var newRequestButton: some View {
        Button {
            showNewRequest = true
        } label: {
            HStack(spacing: BSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Request Blood")
                        .font(BFont.headline())
                        .foregroundColor(.white)

                    Text("Submit a new blood request to nearby donors")
                        .font(BFont.caption())
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(BSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: BRadius.lg)
                    .fill(LinearGradient.bloodGradient)
            )
            .cardShadow()
        }
    }

    // MARK: - Active Requests
    private var activeRequestsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Active Requests")
                .font(BFont.title(20))
                .foregroundColor(.textPrimary)

            ForEach(viewModel.activeRequests) { request in
                RequestCard(request: request)
                    .onTapGesture {
                        selectedRequest = request
                    }
            }
        }
    }

    // MARK: - Completed Requests
    private var completedRequestsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Past Requests")
                .font(BFont.title(20))
                .foregroundColor(.textPrimary)

            ForEach(viewModel.completedRequests) { request in
                RequestCard(request: request)
                    .opacity(0.7)
            }
        }
    }
}

#Preview {
    RequesterDashboard(viewModel: RequesterViewModel(user: MockData.requesterAccount))
}
