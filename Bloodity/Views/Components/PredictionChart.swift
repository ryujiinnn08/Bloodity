import SwiftUI

struct PredictionChart: View {
    let stock: BloodStock
    let weekLabels: [String] = ["Now", "Week 1", "Week 2", "Week 3", "Week 4"]

    var body: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            // Header
            HStack {
                BloodTypeBadge(bloodType: stock.bloodType, size: .medium)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(stock.unitsAvailable) units")
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)

                    Text("Depletes in ~\(stock.predictedDaysUntilDepletion) days")
                        .font(BFont.caption())
                        .foregroundColor(depletionColor)
                }

                Spacer()

                if let severity = stock.severity {
                    HStack(spacing: 4) {
                        Image(systemName: severity.icon)
                        Text(severity.rawValue)
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(severity.color.gradient)
                    )
                }
            }

            // Chart
            chartView
                .frame(height: 80)
                .padding(.top, 4)

            // Week labels
            HStack {
                ForEach(weekLabels, id: \.self) { label in
                    Text(label)
                        .font(BFont.caption(10))
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Usage rate
            HStack {
                Image(systemName: "chart.line.downtrend.xyaxis")
                    .foregroundColor(.textSecondary)
                Text("Daily usage: \(String(format: "%.1f", stock.dailyUsageRate)) units/day")
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    private var depletionColor: Color {
        if stock.predictedDaysUntilDepletion <= 7 { return .bloodRed }
        if stock.predictedDaysUntilDepletion <= 14 { return .warmAmber }
        return .textSecondary
    }

    private var chartView: some View {
        GeometryReader { geometry in
            let maxValue = max(stock.weeklyForecast.max() ?? 1, 1)
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(stock.weeklyForecast.count - 1)

            ZStack {
                // Danger zone
                Rectangle()
                    .fill(Color.bloodRed.opacity(0.08))
                    .frame(height: height * 0.2)
                    .frame(maxWidth: .infinity)
                    .offset(y: height * 0.4)

                // Line chart
                Path { path in
                    for (index, value) in stock.weeklyForecast.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(value) / CGFloat(maxValue)) * height
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [lineColor, lineColor.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                )

                // Fill under curve
                Path { path in
                    for (index, value) in stock.weeklyForecast.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(value) / CGFloat(maxValue)) * height
                        if index == 0 {
                            path.move(to: CGPoint(x: 0, y: height))
                            path.addLine(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.addLine(to: CGPoint(x: CGFloat(stock.weeklyForecast.count - 1) * stepX, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [lineColor.opacity(0.3), lineColor.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Data points
                ForEach(0..<stock.weeklyForecast.count, id: \.self) { index in
                    let value = stock.weeklyForecast[index]
                    let x = CGFloat(index) * stepX
                    let y = height - (CGFloat(value) / CGFloat(maxValue)) * height

                    Circle()
                        .fill(value == 0 ? Color.bloodRed : lineColor)
                        .frame(width: 6, height: 6)
                        .overlay(
                            Circle()
                                .stroke(Color.deepNavy, lineWidth: 1.5)
                        )
                        .position(x: x, y: y)
                }
            }
        }
    }

    private var lineColor: Color {
        if stock.isCritical { return .bloodRed }
        if stock.isLow { return .warmAmber }
        return .successGreen
    }
}

#Preview {
    ZStack {
        Color.deepNavy.ignoresSafeArea()
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                PredictionChart(stock: MockData.bloodStocks[1])
                PredictionChart(stock: MockData.bloodStocks[0])
            }
            .padding()
        }
    }
}
