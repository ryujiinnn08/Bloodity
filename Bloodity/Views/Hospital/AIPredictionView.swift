import SwiftUI

struct AIPredictionView: View {
    @Bindable var viewModel: HospitalViewModel

    @State private var requestTarget: RequestTarget?
    @State private var showDonorPool = false
    @State private var showNotifiedAll = false

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(spacing: BSpacing.xl) {
                    aiHeader
                    if !viewModel.criticalStocks.isEmpty {
                        alertSection(title: "Critical", stocks: viewModel.criticalStocks, color: .bloodRed)
                    }
                    if !viewModel.warningStocks.isEmpty {
                        alertSection(title: "Warning", stocks: viewModel.warningStocks, color: .warmAmber)
                    }
                    allForecastsSection
                    sourcingCascade
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }

            // "Notified All" toast
            if showNotifiedAll {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("All compatible donors notified")
                            .font(BFont.captionBold())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.successGreen.gradient)
                    )
                    .shadow(color: .successGreen.opacity(0.3), radius: 10, y: 4)
                    .padding(.bottom, 120)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationTitle("AI Prediction")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $showDonorPool) {
            DonorPoolView(viewModel: viewModel)
        }
        .sheet(item: $requestTarget) { target in
            BloodRequestSheet(viewModel: viewModel, target: target)
        }
    }

    private var aiHeader: some View {
        VStack(spacing: BSpacing.md) {
            HStack(spacing: BSpacing.md) {
                ZStack {
                    Circle().fill(LinearGradient(colors: [.healBlue, .coralPink], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 56, height: 56)
                    Image(systemName: "brain.head.profile").font(.system(size: 24)).foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Blood Stock Prediction Engine").font(BFont.headline()).foregroundColor(.textPrimary)
                    Text("30-day depletion forecast • Updated today").font(BFont.caption()).foregroundColor(.textSecondary)
                }
                Spacer()
            }
            HStack(spacing: 0) {
                overviewStat(value: "\(viewModel.criticalStocks.count)", label: "Critical", color: .bloodRed)
                overviewStat(value: "\(viewModel.warningStocks.count)", label: "Warning", color: .warmAmber)
                overviewStat(value: "\(viewModel.watchStocks.count)", label: "Watch", color: .warmAmber.opacity(0.7))
                overviewStat(value: "\(viewModel.healthyStocks.count)", label: "Healthy", color: .successGreen)
            }
        }
        .padding(BSpacing.lg).glassCard()
    }

    private func overviewStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(BFont.metric(24)).foregroundColor(color)
            Text(label).font(BFont.caption(11)).foregroundColor(.textSecondary)
        }.frame(maxWidth: .infinity)
    }

    private func alertSection(title: String, stocks: [BloodStock], color: Color) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(color)
                Text("\(title) Alerts").font(BFont.title(20)).foregroundColor(.textPrimary)
            }
            ForEach(stocks) { stock in PredictionChart(stock: stock) }
        }
    }

    private var allForecastsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("All Blood Types").font(BFont.title(20)).foregroundColor(.textPrimary)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(viewModel.bloodStocks) { stock in
                    VStack(spacing: 6) {
                        BloodTypeBadge(bloodType: stock.bloodType, size: .small)
                        Text("\(stock.unitsAvailable)").font(BFont.headline()).foregroundColor(.textPrimary)
                        Text("\(stock.predictedDaysUntilDepletion)d").font(BFont.caption(11))
                            .foregroundColor(stock.predictedDaysUntilDepletion <= 7 ? .bloodRed : stock.predictedDaysUntilDepletion <= 14 ? .warmAmber : .textSecondary)
                    }.frame(maxWidth: .infinity).padding(.vertical, BSpacing.md).glassCard()
                }
            }
        }
    }

    private var sourcingCascade: some View {
        VStack(alignment: .leading, spacing: BSpacing.lg) {
            HStack {
                Image(systemName: "arrow.triangle.branch").foregroundColor(.healBlue)
                Text("Sourcing Cascade").font(BFont.title(20)).foregroundColor(.textPrimary)
            }
            Text("Automated response when shortages are predicted").font(BFont.caption()).foregroundColor(.textSecondary)

            cascadeStep(
                step: 1, title: "Individual Donors",
                desc: "Notify nearby donors with matching blood types",
                icon: "person.fill", color: .successGreen,
                detail: "\(viewModel.availableDonorCount) available",
                actionLabel: "Notify All", showLine: true
            ) {
                withAnimation(.spring(response: 0.3)) {
                    showNotifiedAll = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showNotifiedAll = false }
                }
                // Navigate to donor pool after a brief moment
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showDonorPool = true
                }
            }

            cascadeStep(
                step: 2, title: "Partner Hospitals",
                desc: "Request stock transfer from surplus hospitals",
                icon: "building.2.fill", color: .healBlue,
                detail: "\(MockData.hospitals.filter { $0.isPartner }.count) partners",
                actionLabel: "Send Request", showLine: true
            ) {
                let partnerHospital = MockData.hospitals.first(where: { $0.isPartner && $0.id != viewModel.hospital.id })!
                requestTarget = .hospital(partnerHospital)
            }

            cascadeStep(
                step: 3, title: "Blood Banks",
                desc: "Emergency sourcing from accredited blood banks",
                icon: "cross.case.fill", color: .warmAmber,
                detail: "Red Cross available",
                actionLabel: "Send Request", showLine: false
            ) {
                let redCross = MockData.hospitals.first(where: { $0.name.contains("Red Cross") }) ?? MockData.hospitals.last!
                requestTarget = .redCross(redCross)
            }
        }.padding(BSpacing.lg).glassCard()
    }

    private func cascadeStep(step: Int, title: String, desc: String, icon: String, color: Color, detail: String, actionLabel: String, showLine: Bool, action: @escaping () -> Void) -> some View {
        HStack(alignment: .top, spacing: BSpacing.md) {
            VStack(spacing: 0) {
                ZStack {
                    Circle().fill(color.gradient).frame(width: 32, height: 32)
                    Text("\(step)").font(BFont.captionBold()).foregroundColor(.white)
                }
                if showLine { Rectangle().fill(color.opacity(0.3)).frame(width: 2, height: 30) }
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack { Image(systemName: icon).foregroundColor(color); Text(title).font(BFont.headline(15)).foregroundColor(.textPrimary) }
                Text(desc).font(BFont.caption()).foregroundColor(.textSecondary)
                HStack {
                    Text(detail).font(BFont.caption(11)).foregroundColor(color)
                    Spacer()
                    Button(action: action) {
                        Text(actionLabel)
                            .font(BFont.captionBold(11))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(color.gradient))
                    }
                }
            }
        }
    }
}

#Preview { NavigationStack { AIPredictionView(viewModel: HospitalViewModel(user: MockData.hospitalAccount)) } }

