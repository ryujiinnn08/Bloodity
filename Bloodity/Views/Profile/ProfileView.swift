import SwiftUI

struct ProfileView: View {
    let user: User
    var onLogout: () -> Void

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(spacing: BSpacing.xl) {
                    profileHeader
                    infoSection
                    statsSection
                    if user.role == .user { donorSection }
                    aboutSection
                    logoutButton
                }
                .padding(.horizontal).padding(.bottom, 100)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }

    private var profileHeader: some View {
        VStack(spacing: BSpacing.md) {
            ZStack {
                Circle().fill(user.role.color.gradient).frame(width: 80, height: 80)
                Text(String(user.name.prefix(1))).font(BFont.display(32)).foregroundColor(.white)
            }
            Text(user.name).font(BFont.title()).foregroundColor(.textPrimary)
            HStack(spacing: BSpacing.sm) {
                Image(systemName: user.role.icon).foregroundColor(user.role.color)
                Text(user.role.rawValue).font(BFont.body()).foregroundColor(user.role.color)
                Text("•").foregroundColor(.textSecondary)
                BloodTypeBadge(bloodType: user.bloodType, size: .small)
            }
        }.padding(.vertical, BSpacing.xl).frame(maxWidth: .infinity).glassCard()
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Account Info").font(BFont.headline()).foregroundColor(.textPrimary)
            infoRow(icon: "phone.fill", label: "Phone", value: user.phone)
            infoRow(icon: "drop.fill", label: "Blood Type", value: user.bloodType.rawValue)
            infoRow(icon: "person.fill", label: "Role", value: user.role.rawValue)
            infoRow(icon: "calendar", label: "Member Since", value: memberSince)
        }.padding(BSpacing.lg).glassCard()
    }

    private var statsSection: some View {
        HStack(spacing: 0) {
            statCol(value: "\(user.totalDonations)", label: "Donations", color: .bloodRed)
            Divider().frame(height: 40).background(Color.white.opacity(0.1))
            statCol(value: "\(user.totalDonations * 3)", label: "Lives Saved", color: .coralPink)
            Divider().frame(height: 40).background(Color.white.opacity(0.1))
            statCol(value: user.isEligibleToDonate ? "Yes" : "No", label: "Eligible", color: user.isEligibleToDonate ? .successGreen : .warmAmber)
        }.padding(.vertical, BSpacing.lg).glassCard()
    }

    private var donorSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Donor Status").font(BFont.headline()).foregroundColor(.textPrimary)
            HStack {
                PulsingDot(color: user.isAvailable ? .successGreen : .textSecondary)
                Text(user.isAvailable ? "Available" : "Unavailable").font(BFont.body()).foregroundColor(user.isAvailable ? .successGreen : .textSecondary)
                Spacer()
                if !user.isEligibleToDonate {
                    Text("\(user.daysUntilEligible) days until eligible").font(BFont.caption()).foregroundColor(.warmAmber)
                }
            }
        }.padding(BSpacing.lg).glassCard()
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("About Bloodity").font(BFont.headline()).foregroundColor(.textPrimary)
            Text("Bloodity is an AI-based blood stock forecasting and donor matching system designed to address the critical blood shortage in the Philippines.")
                .font(BFont.caption()).foregroundColor(.textSecondary)
            HStack {
                Text("Version 1.0.0").font(BFont.caption(11)).foregroundColor(.textSecondary.opacity(0.5))
                Spacer()
                Text("by LWKY").font(BFont.caption(11)).foregroundColor(.textSecondary.opacity(0.5))
            }
        }.padding(BSpacing.lg).glassCard()
    }

    private var logoutButton: some View {
        Button(action: onLogout) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
            }
        }.buttonStyle(SecondaryButtonStyle())
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: BSpacing.md) {
            Image(systemName: icon).font(.system(size: 14)).foregroundColor(.textSecondary).frame(width: 20)
            Text(label).font(BFont.body()).foregroundColor(.textSecondary)
            Spacer()
            Text(value).font(BFont.body()).foregroundColor(.textPrimary)
        }
    }

    private func statCol(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(BFont.headline()).foregroundColor(color)
            Text(label).font(BFont.caption(11)).foregroundColor(.textSecondary)
        }.frame(maxWidth: .infinity)
    }

    private var memberSince: String {
        let f = DateFormatter(); f.dateFormat = "MMM yyyy"; return f.string(from: user.registrationDate)
    }
}

#Preview { NavigationStack { ProfileView(user: MockData.userAccount, onLogout: {}) } }
