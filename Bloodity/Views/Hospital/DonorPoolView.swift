import SwiftUI

struct DonorPoolView: View {
    @Bindable var viewModel: HospitalViewModel
    @State private var searchText = ""
    @State private var requestedDonorId: UUID?
    @State private var expandedDonorId: UUID?

    var displayedDonors: [User] {
        let donors = viewModel.filteredDonors
        if searchText.isEmpty { return donors }
        return donors.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: BSpacing.lg) {
                    // Search Bar
                    searchBar

                    // Blood Type Filter
                    bloodTypeFilter

                    // Stats
                    donorStats

                    // Hint
                    if expandedDonorId == nil {
                        HStack(spacing: 6) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 11))
                            Text("Tap a donor to view full details")
                                .font(BFont.caption(12))
                        }
                        .foregroundColor(.textSecondary.opacity(0.6))
                        .transition(.opacity)
                    }

                    // Donor List
                    donorList
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Donor Pool")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Search
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            TextField("", text: $searchText, prompt: Text("Search donors...").foregroundColor(.textSecondary.opacity(0.5)))
                .foregroundColor(.textPrimary)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BRadius.md)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    // MARK: - Blood Type Filter
    private var bloodTypeFilter: some View {
        ScrollView(.horizontal) {
            HStack(spacing: BSpacing.sm) {
                filterChip(label: "All", isSelected: viewModel.selectedBloodTypeFilter == nil) {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.selectedBloodTypeFilter = nil
                    }
                }

                ForEach(BloodType.allCases) { type in
                    filterChip(
                        label: type.rawValue,
                        isSelected: viewModel.selectedBloodTypeFilter == type,
                        color: type.color
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedBloodTypeFilter = type
                        }
                    }
                }
            }
        }
    }

    private func filterChip(label: String, isSelected: Bool, color: Color = .healBlue, action: @escaping () -> Void) -> some View {
        let bgGradient: AnyGradient = isSelected ? color.gradient : Color.cardDark.gradient
        let borderColor: Color = isSelected ? .clear : .white.opacity(0.08)
        return Button(action: action) {
            Text(label)
                .font(BFont.captionBold())
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(bgGradient)
                )
                .overlay(
                    Capsule()
                        .stroke(borderColor, lineWidth: 1)
                )
        }
    }

    // MARK: - Stats
    private var donorStats: some View {
        HStack(spacing: BSpacing.md) {
            miniStat(
                value: "\(displayedDonors.count)",
                label: "Total",
                color: .healBlue
            )

            miniStat(
                value: "\(displayedDonors.filter { $0.isAvailable && $0.isEligibleToDonate }.count)",
                label: "Available",
                color: .successGreen
            )

            miniStat(
                value: "\(displayedDonors.filter { !$0.isEligibleToDonate }.count)",
                label: "Cooldown",
                color: .warmAmber
            )
        }
    }

    private func miniStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(BFont.headline())
                .foregroundColor(color)
            Text(label)
                .font(BFont.caption(11))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, BSpacing.md)
        .glassCard()
    }

    // MARK: - Donor List
    private var donorList: some View {
        VStack(spacing: BSpacing.sm) {
            ForEach(displayedDonors) { donor in
                DonorCard(
                    donor: donor,
                    hospitalLat: viewModel.hospital.latitude,
                    hospitalLon: viewModel.hospital.longitude,
                    isExpanded: Binding(
                        get: { expandedDonorId == donor.id },
                        set: { newValue in
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                expandedDonorId = newValue ? donor.id : nil
                            }
                        }
                    ),
                    onRequestDonation: {
                        withAnimation(.spring(response: 0.3)) {
                            requestedDonorId = donor.id
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                requestedDonorId = nil
                            }
                        }
                    }
                )
                .overlay(
                    Group {
                        if requestedDonorId == donor.id {
                            RoundedRectangle(cornerRadius: BRadius.lg)
                                .fill(Color.white.opacity(0.95))
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.successGreen)
                                        Text("Request Sent")
                                            .font(BFont.headline())
                                            .foregroundColor(.successGreen)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: BRadius.lg)
                                        .stroke(Color.successGreen.opacity(0.3), lineWidth: 1.5)
                                )
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        DonorPoolView(viewModel: HospitalViewModel(user: MockData.hospitalAccount))
    }
}

