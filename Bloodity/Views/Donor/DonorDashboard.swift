import SwiftUI

struct DonorDashboard: View {
    @Bindable var viewModel: DonorViewModel

    @State private var showRequestDetail: BloodRequest?
    @State private var navigatingRequest: BloodRequest?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical) {
                    VStack(spacing: BSpacing.xl) {
                        // Hero Section
                        heroSection

                        // Quick Stats
                        quickStats

                        // Active Nearby Requests
                        if !viewModel.compatibleRequests.isEmpty {
                            nearbyRequestsSection
                        } else {
                            emptyRequestsView
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
            .sheet(item: $showRequestDetail) { request in
                DonorRequestDetailView(
                    request: request,
                    donor: viewModel.currentUser,
                    onAccept: {
                        viewModel.acceptRequest(request)
                        showRequestDetail = nil
                        // Push navigation view after a brief delay for sheet dismiss
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            navigatingRequest = request
                        }
                    },
                    onDecline: {
                        viewModel.declineRequest(request)
                        showRequestDetail = nil
                    }
                )
            }
            .navigationDestination(item: $navigatingRequest) { request in
                DonorNavigationView(
                    request: request,
                    donor: viewModel.currentUser,
                    onComplete: {
                        navigatingRequest = nil
                    }
                )
            }
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: BSpacing.lg) {
            // Availability toggle
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome, \(viewModel.currentUser.name.components(separatedBy: " ").first ?? "Donor")!")
                        .font(BFont.title())
                        .foregroundColor(.textPrimary)

                    HStack(spacing: 6) {
                        PulsingDot(color: viewModel.isAvailable ? .successGreen : .textSecondary)
                        Text(viewModel.isAvailable ? "Available to donate" : "Unavailable")
                            .font(BFont.body())
                            .foregroundColor(viewModel.isAvailable ? .successGreen : .textSecondary)
                    }
                }

                Spacer()

                // Toggle
                Button {
                    viewModel.toggleAvailability()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                        Text(viewModel.isAvailable ? "ON" : "OFF")
                            .font(BFont.captionBold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(viewModel.isAvailable ?
                                  AnyShapeStyle(Color.successGreen.gradient) :
                                  AnyShapeStyle(Color.surfaceDark.gradient))
                    )
                }
            }
            .padding(BSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: BRadius.xl)
                    .fill(
                        LinearGradient(
                            colors: [
                                viewModel.isAvailable ? Color.successGreen.opacity(0.15) : Color.surfaceDark.opacity(0.3),
                                Color.cardDark
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: BRadius.xl)
                            .stroke(
                                viewModel.isAvailable ? Color.successGreen.opacity(0.2) : Color.white.opacity(0.05),
                                lineWidth: 1
                            )
                    )
            )

            // Eligibility banner
            if !viewModel.currentUser.isEligibleToDonate {
                eligibilityBanner
            }
        }
        .padding(.top, BSpacing.sm)
    }

    // MARK: - Eligibility Banner
    private var eligibilityBanner: some View {
        HStack(spacing: BSpacing.md) {
            // Circular progress
            ZStack {
                Circle()
                    .stroke(Color.surfaceDark, lineWidth: 4)
                    .frame(width: 50, height: 50)

                Circle()
                    .trim(from: 0, to: viewModel.currentUser.eligibilityProgress)
                    .stroke(
                        LinearGradient.bloodGradient,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))

                Text("\(viewModel.currentUser.daysUntilEligible)")
                    .font(BFont.headline(14))
                    .foregroundColor(.coralPink)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Recovery Period")
                    .font(BFont.headline(14))
                    .foregroundColor(.textPrimary)

                Text("\(viewModel.currentUser.daysUntilEligible) days until you're eligible to donate again")
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Quick Stats
    private var quickStats: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: BSpacing.md) {
            MetricCard(
                title: "Donations",
                value: "\(viewModel.currentUser.totalDonations)",
                icon: "drop.fill",
                color: .bloodRed
            )

            MetricCard(
                title: "Lives Saved",
                value: "\(viewModel.currentUser.totalDonations * 3)",
                icon: "heart.fill",
                color: .coralPink
            )

            MetricCard(
                title: "Nearby Requests",
                value: "\(viewModel.activeRequestCount)",
                icon: "mappin.and.ellipse",
                color: .warmAmber
            )

            MetricCard(
                title: "Blood Type",
                value: viewModel.currentUser.bloodType.rawValue,
                icon: "cross.vial.fill",
                color: viewModel.currentUser.bloodType.color
            )
        }
    }

    // MARK: - Nearby Requests
    private var nearbyRequestsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Text("Nearby Requests")
                    .font(BFont.title(20))
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(viewModel.compatibleRequests.count) compatible")
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }

            ForEach(viewModel.compatibleRequests) { request in
                RequestCard(
                    request: request,
                    showActions: true,
                    onAccept: {
                        showRequestDetail = request
                    }
                )
                .onTapGesture {
                    showRequestDetail = request
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyRequestsView: some View {
        VStack(spacing: BSpacing.lg) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.successGreen.opacity(0.5))

            Text("No Active Requests")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            Text("There are currently no blood requests matching your blood type nearby. We'll notify you when one appears.")
                .font(BFont.body())
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, BSpacing.xxxl)
        .padding(.horizontal)
    }
}

#Preview {
    DonorDashboard(viewModel: DonorViewModel(user: MockData.userAccount))
}
