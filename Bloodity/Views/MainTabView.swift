import SwiftUI

struct MainTabView: View {
    let user: User
    let authVM: AuthViewModel
    var store = DataStore.shared

    var body: some View {
        Group {
            switch user.role {
            case .user: userTabs
            case .hospital: hospitalTabs
            }
        }
        .tint(.bloodRed)
    }

    // MARK: - User Tabs (Donor + Recipient combined)
    private var userTabs: some View {
        let donorVM = DonorViewModel(user: user)
        let requesterVM = RequesterViewModel(user: user)
        return TabView {
            UserDashboard(donorVM: donorVM, requesterVM: requesterVM)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NavigationStack {
                DonorHistoryView(donations: store.donations, user: user)
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }

            NavigationStack {
                NotificationCenterView(notifications: store.donorNotifications)
            }
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }
            .badge(store.unreadDonorNotificationCount)

            NavigationStack {
                ProfileView(user: user, onLogout: { authVM.logout() })
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }

    // MARK: - Hospital Tabs
    private var hospitalTabs: some View {
        let vm = HospitalViewModel(user: user)
        return TabView {
            HospitalDashboard(viewModel: vm)
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }

            NavigationStack {
                DonorPoolView(viewModel: vm)
            }
            .tabItem {
                Label("Donors", systemImage: "person.2.fill")
            }

            NavigationStack {
                AIPredictionView(viewModel: vm)
            }
            .tabItem {
                Label("AI Predict", systemImage: "brain.head.profile")
            }
            .badge(vm.criticalStocks.count)

            NavigationStack {
                NotificationCenterView(notifications: store.hospitalNotifications)
            }
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }
            .badge(store.unreadHospitalNotificationCount)

            NavigationStack {
                ProfileView(user: user, onLogout: { authVM.logout() })
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

#Preview {
    MainTabView(user: MockData.userAccount, authVM: AuthViewModel())
}
