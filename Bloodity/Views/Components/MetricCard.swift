import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var subtitle: String? = nil
    var trend: String? = nil

    @State private var isAnimated = false

    var body: some View {
        VStack(alignment: .leading, spacing: BSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color.opacity(0.15))
                    )

                Spacer()

                if let trend = trend {
                    Text(trend)
                        .font(BFont.caption(11))
                        .foregroundColor(.successGreen)
                }
            }

            Text(value)
                .font(BFont.metric(28))
                .foregroundColor(.textPrimary)
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .opacity(isAnimated ? 1.0 : 0)

            Text(title)
                .font(BFont.caption())
                .foregroundColor(.textSecondary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary.opacity(0.7))
            }
        }
        .padding(BSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.deepNavy.ignoresSafeArea()
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricCard(title: "Active Requests", value: "12", icon: "drop.fill", color: .bloodRed, trend: "+3")
            MetricCard(title: "Available Donors", value: "48", icon: "person.2.fill", color: .successGreen)
            MetricCard(title: "Units in Stock", value: "175", icon: "cross.vial.fill", color: .healBlue)
            MetricCard(title: "Fulfilled Today", value: "7", icon: "checkmark.circle.fill", color: .coralPink)
        }
        .padding()
    }
}
