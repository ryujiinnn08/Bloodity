import SwiftUI

struct AdminHospitalListView: View {
    var store = DataStore.shared
    @State private var selectedFilter: HospitalFilter = .all

    enum HospitalFilter: String, CaseIterable {
        case all = "All"
        case verified = "Verified"
        case pending = "Pending"
    }

    var filteredHospitals: [Hospital] {
        switch selectedFilter {
        case .all: return store.hospitals
        case .verified: return store.verifiedHospitals
        case .pending: return store.pendingHospitals
        }
    }

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: BSpacing.lg) {
                    // Filter
                    HStack(spacing: 0) {
                        ForEach(HospitalFilter.allCases, id: \.rawValue) { filter in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedFilter = filter
                                }
                            } label: {
                                Text(filter.rawValue)
                                    .font(BFont.captionBold(13))
                                    .foregroundColor(selectedFilter == filter ? .white : .textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(
                                        Group {
                                            if selectedFilter == filter {
                                                RoundedRectangle(cornerRadius: BRadius.sm)
                                                    .fill(Color.warmAmber)
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

                    // Hospital cards
                    if filteredHospitals.isEmpty {
                        VStack(spacing: BSpacing.md) {
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.textSecondary.opacity(0.4))
                            Text("No hospitals in this category")
                                .font(BFont.body())
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.vertical, BSpacing.xxxl)
                        .frame(maxWidth: .infinity)
                    } else {
                        ForEach(filteredHospitals) { hospital in
                            hospitalCard(hospital)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Hospitals")
        .navigationBarTitleDisplayMode(.large)
    }

    private func hospitalCard(_ hospital: Hospital) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            // Header row
            HStack(spacing: BSpacing.md) {
                ZStack {
                    Circle()
                        .fill(hospital.isVerified ? Color.healBlue.opacity(0.15) : Color.warmAmber.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(hospital.isVerified ? .healBlue : .warmAmber)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(hospital.name)
                        .font(BFont.headline(15))
                        .foregroundColor(.textPrimary)
                    Text(hospital.address)
                        .font(BFont.caption(12))
                        .foregroundColor(.textSecondary)
                }

                Spacer()
            }

            // Info row
            HStack(spacing: BSpacing.lg) {
                Label(hospital.contactNumber, systemImage: "phone.fill")
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
            }

            // Status + Actions
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(hospital.isVerified ? Color.successGreen : Color.warmAmber)
                        .frame(width: 8, height: 8)
                    Text(hospital.isVerified ? "Verified" : "Pending Review")
                        .font(BFont.captionBold(12))
                        .foregroundColor(hospital.isVerified ? .successGreen : .warmAmber)
                }

                Spacer()

                if !hospital.isVerified {
                    HStack(spacing: BSpacing.sm) {
                        Button {
                            store.rejectHospital(hospital.id)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.bloodRed)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color.bloodRed.opacity(0.1))
                                )
                        }

                        Button {
                            store.verifyHospital(hospital.id)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                Text("Verify")
                                    .font(BFont.captionBold(12))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .frame(height: 32)
                            .background(
                                Capsule()
                                    .fill(Color.successGreen)
                            )
                        }
                    }
                } else if hospital.isPartner {
                    Text("Partner")
                        .font(BFont.caption(11))
                        .foregroundColor(.healBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.healBlue.opacity(0.1))
                        )
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }
}

#Preview {
    NavigationStack {
        AdminHospitalListView()
    }
}
