import SwiftUI

struct NotificationCenterView: View {
    let notifications: [AppNotification]
    @State private var readIds: Set<UUID> = []

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(spacing: BSpacing.sm) {
                    if notifications.isEmpty {
                        emptyState
                    } else {
                        ForEach(notifications) { notification in
                            notificationRow(notification)
                                .onTapGesture {
                                    let _ = withAnimation {
                                        readIds.insert(notification.id)
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal).padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
    }

    private func notificationRow(_ notification: AppNotification) -> some View {
        let isUnread = !notification.isRead && !readIds.contains(notification.id)
        return HStack(alignment: .top, spacing: BSpacing.md) {
            ZStack {
                Circle()
                    .fill(notificationColor(notification.type).opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: notification.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(notificationColor(notification.type))
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(BFont.headline(14))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Text(notification.timeAgo)
                        .font(BFont.caption(11))
                        .foregroundColor(.textSecondary)
                }
                Text(notification.message)
                    .font(BFont.caption())
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
            if isUnread {
                Circle().fill(Color.bloodRed).frame(width: 8, height: 8)
            }
        }
        .padding(BSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: BRadius.md)
                .fill(isUnread ? Color.bloodRed.opacity(0.08) : Color.cardDark.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .stroke(isUnread ? Color.bloodRed.opacity(0.2) : Color.white.opacity(0.05), lineWidth: 1)
                )
        )
    }

    private func notificationColor(_ type: NotificationType) -> Color {
        switch type {
        case .newRequest: return .bloodRed
        case .donorFound: return .healBlue
        case .fulfilled: return .successGreen
        case .eligibilityRestored: return .coralPink
        case .predictionAlert: return .warmAmber
        case .systemAlert: return .textSecondary
        }
    }

    private var emptyState: some View {
        VStack(spacing: BSpacing.md) {
            Image(systemName: "bell.slash.fill").font(.system(size: 40)).foregroundColor(.textSecondary.opacity(0.4))
            Text("No notifications").font(BFont.headline()).foregroundColor(.textSecondary)
            Text("You'll see alerts for blood requests, matches, and eligibility updates here.")
                .font(BFont.caption()).foregroundColor(.textSecondary.opacity(0.7)).multilineTextAlignment(.center)
        }.padding(.vertical, 60)
    }
}

#Preview {
    NavigationStack { NotificationCenterView(notifications: MockData.donorNotifications) }
}
