import SwiftUI

struct AdminUsersView: View {
    var store = DataStore.shared

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: BSpacing.lg) {
                    // Stats bar
                    HStack(spacing: 0) {
                        statCol(
                            value: "\(store.donors.count)",
                            label: "Total",
                            color: .textPrimary
                        )
                        Divider().frame(height: 30)
                        statCol(
                            value: "\(store.donors.filter { $0.isAvailable && $0.isEligibleToDonate }.count)",
                            label: "Available",
                            color: .successGreen
                        )
                        Divider().frame(height: 30)
                        statCol(
                            value: "\(store.donors.filter { !$0.isEligibleToDonate }.count)",
                            label: "Cooldown",
                            color: .warmAmber
                        )
                    }
                    .padding(.vertical, BSpacing.md)
                    .glassCard()

                    // User list
                    ForEach(store.donors) { donor in
                        HStack(spacing: BSpacing.md) {
                            ZStack {
                                Circle()
                                    .fill(donor.bloodType.color.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Text(String(donor.name.prefix(1)))
                                    .font(BFont.headline())
                                    .foregroundColor(donor.bloodType.color)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(donor.name)
                                    .font(BFont.headline(14))
                                    .foregroundColor(.textPrimary)
                                HStack(spacing: 6) {
                                    Text(donor.bloodType.rawValue)
                                        .font(BFont.captionBold(11))
                                        .foregroundColor(donor.bloodType.color)
                                    Text("•")
                                        .foregroundColor(.textSecondary)
                                    Text("\(donor.totalDonations) donations")
                                        .font(BFont.caption(11))
                                        .foregroundColor(.textSecondary)
                                }
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(donor.isAvailable ? Color.successGreen : Color.textSecondary)
                                        .frame(width: 6, height: 6)
                                    Text(donor.isAvailable ? "Active" : "Inactive")
                                        .font(BFont.caption(10))
                                        .foregroundColor(donor.isAvailable ? .successGreen : .textSecondary)
                                }
                                if !donor.isEligibleToDonate {
                                    Text("\(donor.daysUntilEligible)d left")
                                        .font(BFont.caption(10))
                                        .foregroundColor(.warmAmber)
                                }
                            }
                        }
                        .padding(BSpacing.md)
                        .glassCard()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Users")
        .navigationBarTitleDisplayMode(.large)
    }

    private func statCol(value: String, label: String, color: Color) -> some View {
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
    NavigationStack {
        AdminUsersView()
    }
}
