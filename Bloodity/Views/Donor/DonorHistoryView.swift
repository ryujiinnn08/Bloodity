import SwiftUI

struct DonorHistoryView: View {
    let donations: [Donation]
    let user: User

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: BSpacing.xl) {
                    // Summary Card
                    summaryCard

                    // Eligibility Card
                    eligibilityCard

                    // History List
                    historySection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Donation History")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Summary
    private var summaryCard: some View {
        HStack(spacing: 0) {
            statColumn(value: "\(donations.count)", label: "Donations", icon: "drop.fill", color: .bloodRed)

            Divider()
                .frame(height: 50)
                .background(Color.white.opacity(0.1))

            statColumn(value: "\(donations.count * 3)", label: "Lives Saved", icon: "heart.fill", color: .coralPink)

            Divider()
                .frame(height: 50)
                .background(Color.white.opacity(0.1))

            statColumn(value: "\(donations.reduce(0) { $0 + $1.unitsDonated })", label: "Units Given", icon: "cross.vial.fill", color: .healBlue)
        }
        .padding(.vertical, BSpacing.xl)
        .glassCard()
    }

    private func statColumn(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)

            Text(value)
                .font(BFont.metric(24))
                .foregroundColor(.textPrimary)

            Text(label)
                .font(BFont.caption(11))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Eligibility
    private var eligibilityCard: some View {
        VStack(spacing: BSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.isEligibleToDonate ? "Ready to Donate" : "Recovery Period")
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)

                    Text(user.isEligibleToDonate ?
                         "You're eligible to donate blood again!" :
                         "\(user.daysUntilEligible) days remaining until next eligibility")
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                // Circular progress
                ZStack {
                    Circle()
                        .stroke(Color.surfaceDark, lineWidth: 6)
                        .frame(width: 60, height: 60)

                    Circle()
                        .trim(from: 0, to: user.eligibilityProgress)
                        .stroke(
                            user.isEligibleToDonate ?
                                AnyShapeStyle(Color.successGreen.gradient) :
                                AnyShapeStyle(LinearGradient.bloodGradient),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))

                    Image(systemName: user.isEligibleToDonate ? "checkmark" : "hourglass")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(user.isEligibleToDonate ? .successGreen : .coralPink)
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.surfaceDark)
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient.bloodGradient)
                        .frame(width: geometry.size.width * user.eligibilityProgress, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Last Donation")
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
                Spacer()
                Text("56 Days")
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - History
    private var historySection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Past Donations")
                .font(BFont.title(20))
                .foregroundColor(.textPrimary)

            if donations.isEmpty {
                VStack(spacing: BSpacing.md) {
                    Image(systemName: "drop.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary.opacity(0.4))
                    Text("No donations yet")
                        .font(BFont.body())
                        .foregroundColor(.textSecondary)
                    Text("Your donation history will appear here after your first donation.")
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, BSpacing.xxxl)
                .frame(maxWidth: .infinity)
            } else {
                ForEach(donations) { donation in
                    donationRow(donation)
                }
            }
        }
    }

    private func donationRow(_ donation: Donation) -> some View {
        HStack(spacing: BSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.bloodRed.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: "drop.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.bloodRed)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(donation.hospitalName)
                    .font(BFont.headline(15))
                    .foregroundColor(.textPrimary)

                Text(donation.formattedDate)
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                BloodTypeBadge(bloodType: donation.bloodType, size: .small)
                Text("\(donation.unitsDonated) unit\(donation.unitsDonated > 1 ? "s" : "")")
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(BSpacing.md)
        .glassCard()
    }
}

#Preview {
    NavigationStack {
        DonorHistoryView(
            donations: MockData.donations,
            user: MockData.userAccount
        )
    }
}
