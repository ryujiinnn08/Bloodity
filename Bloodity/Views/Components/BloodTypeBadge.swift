import SwiftUI

struct BloodTypeBadge: View {
    let bloodType: BloodType
    var size: BadgeSize = .medium

    enum BadgeSize {
        case small, medium, large

        var fontSize: CGFloat {
            switch self {
            case .small: return 11
            case .medium: return 14
            case .large: return 18
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6)
            case .medium: return EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            case .large: return EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 12
            }
        }
    }

    var body: some View {
        Text(bloodType.rawValue)
            .font(.system(size: size.fontSize, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(size.padding)
            .background(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(bloodType.color.gradient)
            )
    }
}

struct UrgencyChip: View {
    let urgency: UrgencyLevel

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: urgency.icon)
                .font(.system(size: 10))
            Text(urgency.rawValue)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(urgency.color.gradient)
        )
    }
}

struct StatusChip: View {
    let status: RequestStatus

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.system(size: 10))
            Text(status.rawValue)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(status.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(status.color.opacity(0.15))
                .overlay(
                    Capsule()
                        .stroke(status.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.deepNavy.ignoresSafeArea()
        VStack(spacing: 20) {
            HStack {
                ForEach(BloodType.allCases) { type in
                    BloodTypeBadge(bloodType: type, size: .medium)
                }
            }
            HStack {
                ForEach(UrgencyLevel.allCases, id: \.rawValue) { level in
                    UrgencyChip(urgency: level)
                }
            }
            HStack {
                ForEach(RequestStatus.allCases, id: \.rawValue) { status in
                    StatusChip(status: status)
                }
            }
        }
    }
}
