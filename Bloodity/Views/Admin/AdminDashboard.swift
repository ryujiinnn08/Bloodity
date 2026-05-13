import SwiftUI

struct AdminDashboard: View {
    var store = DataStore.shared

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    // Header
                    headerSection

                    VStack(spacing: BSpacing.lg) {
                        // System Metrics
                        metricsGrid

                        // Pending Hospitals
                        if !store.pendingHospitals.isEmpty {
                            pendingSection
                        }

                        // Active Requests Overview
                        activeRequestsSection

                        // Blood Stock Summary
                        stockSummarySection
                    }
                    .padding(.horizontal)
                    .padding(.top, BSpacing.lg)
                    .padding(.bottom, 100)
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.deepNavy)
            .ignoresSafeArea(edges: .top)
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(red: 0.35, green: 0.25, blue: 0.05), Color.warmAmber.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 160)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("BLOODITY ADMIN")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(2)

                    Text("System Overview")
                        .font(BFont.title(24))
                        .foregroundColor(.white)

                    Text("Manage hospitals, users & blood supply")
                        .font(BFont.caption(12))
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, BSpacing.lg)
        }
    }

    // MARK: - Metrics Grid
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            metricCard(
                title: "Total Users",
                value: "\(store.donors.count)",
                icon: "person.2.fill",
                color: .bloodRed
            )
            metricCard(
                title: "Hospitals",
                value: "\(store.verifiedHospitals.count)",
                icon: "building.2.fill",
                color: .healBlue
            )
            metricCard(
                title: "Active Requests",
                value: "\(store.allActiveRequests.count)",
                icon: "drop.fill",
                color: .warmAmber
            )
            metricCard(
                title: "Units in Stock",
                value: "\(store.bloodStocks.reduce(0) { $0 + $1.unitsAvailable })",
                icon: "cross.vial.fill",
                color: .successGreen
            )
        }
    }

    private func metricCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                Spacer()
            }
            Text(value)
                .font(BFont.metric(28))
                .foregroundColor(.textPrimary)
            Text(title)
                .font(BFont.caption(12))
                .foregroundColor(.textSecondary)
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Pending Hospitals
    private var pendingSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Text("PENDING VERIFICATION")
                    .font(BFont.captionBold(12))
                    .foregroundColor(.warmAmber)
                    .tracking(0.5)

                Spacer()

                Text("\(store.pendingHospitals.count)")
                    .font(BFont.captionBold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.warmAmber))
            }

            ForEach(store.pendingHospitals) { hospital in
                pendingHospitalCard(hospital)
            }
        }
    }

    private func pendingHospitalCard(_ hospital: Hospital) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.warmAmber.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.warmAmber)
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

                Text("Pending")
                    .font(BFont.caption(11))
                    .foregroundColor(.warmAmber)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(Color.warmAmber.opacity(0.12))
                    )
            }

            HStack(spacing: BSpacing.md) {
                Button {
                    store.rejectHospital(hospital.id)
                } label: {
                    Text("Reject")
                        .font(BFont.captionBold())
                        .foregroundColor(.bloodRed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.sm)
                                .stroke(Color.bloodRed.opacity(0.4), lineWidth: 1)
                        )
                }

                Button {
                    store.verifyHospital(hospital.id)
                } label: {
                    Text("Verify")
                        .font(BFont.captionBold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.sm)
                                .fill(Color.successGreen)
                        )
                }
            }
        }
        .padding(BSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .fill(Color.white)
                .shadow(color: .warmAmber.opacity(0.1), radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: BRadius.lg)
                .stroke(Color.warmAmber.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: - Active Requests
    private var activeRequestsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("ACTIVE BLOOD REQUESTS")
                .font(BFont.captionBold(12))
                .foregroundColor(.textSecondary)
                .tracking(0.5)

            if store.allActiveRequests.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.successGreen)
                        Text("All requests fulfilled")
                            .font(BFont.body())
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.vertical, BSpacing.xl)
                    Spacer()
                }
                .glassCard()
            } else {
                ForEach(store.allActiveRequests) { request in
                    HStack(spacing: BSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(request.urgencyLevel.color.opacity(0.15))
                                .frame(width: 36, height: 36)
                            Image(systemName: request.urgencyLevel.icon)
                                .font(.system(size: 14))
                                .foregroundColor(request.urgencyLevel.color)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(request.patientName)
                                .font(BFont.headline(14))
                                .foregroundColor(.textPrimary)
                            Text("\(request.hospitalName) • \(request.bloodTypeNeeded.rawValue)")
                                .font(BFont.caption(12))
                                .foregroundColor(.textSecondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text(request.urgencyLevel.rawValue)
                                .font(BFont.caption(11))
                                .foregroundColor(request.urgencyLevel.color)
                            Text(request.status.rawValue)
                                .font(BFont.caption(10))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .padding(BSpacing.md)
                    .glassCard()
                }
            }
        }
    }

    // MARK: - Stock Summary
    private var stockSummarySection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("BLOOD STOCK OVERVIEW")
                .font(BFont.captionBold(12))
                .foregroundColor(.textSecondary)
                .tracking(0.5)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(store.bloodStocks) { stock in
                    HStack(spacing: BSpacing.sm) {
                        Text(stock.bloodType.rawValue)
                            .font(BFont.headline(14))
                            .foregroundColor(stock.bloodType.color)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(stock.unitsAvailable) units")
                                .font(BFont.captionBold(12))
                                .foregroundColor(.textPrimary)

                            // Mini bar
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.surfaceDark)
                                        .frame(height: 4)
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(stockBarColor(stock))
                                        .frame(width: geo.size.width * min(1.0, Double(stock.unitsAvailable) / 50.0), height: 4)
                                }
                            }
                            .frame(height: 4)
                        }
                    }
                    .padding(BSpacing.sm)
                    .padding(.vertical, 2)
                    .glassCard(cornerRadius: BRadius.sm)
                }
            }
        }
    }

    private func stockBarColor(_ stock: BloodStock) -> Color {
        if let severity = stock.severity {
            return severity.color
        }
        return .successGreen
    }
}

#Preview {
    AdminDashboard()
}
