import SwiftUI

struct MainTabView: View {
    let user: User
    let authVM: AuthViewModel

    var body: some View {
        Group {
            switch user.role {
            case .donor: donorTabs
            case .requester: requesterTabs
            case .hospital: hospitalTabs
            }
        }
        .tint(.bloodRed)
    }

    // MARK: - Donor Tabs
    private var donorTabs: some View {
        let vm = DonorViewModel(user: user)
        return TabView {
            DonorDashboard(viewModel: vm)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NavigationStack {
                DonorHistoryView(donations: vm.donationHistory, user: user)
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }

            NavigationStack {
                NotificationCenterView(notifications: MockData.donorNotifications)
            }
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }
            .badge(MockData.donorNotifications.filter { !$0.isRead }.count)

            NavigationStack {
                ProfileView(user: user, onLogout: { authVM.logout() })
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }

    // MARK: - Requester Tabs
    private var requesterTabs: some View {
        let vm = RequesterViewModel(user: user)
        return TabView {
            RequesterDashboard(viewModel: vm)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NavigationStack {
                NotificationCenterView(notifications: MockData.donorNotifications)
            }
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }

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
                NotificationCenterView(notifications: MockData.hospitalNotifications)
            }
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }
            .badge(MockData.hospitalNotifications.filter { !$0.isRead }.count)

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
    MainTabView(user: MockData.donorAccount, authVM: AuthViewModel())
}
