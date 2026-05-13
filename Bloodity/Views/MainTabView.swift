import SwiftUI

struct MainTabView: View {
    let user: User
    let authVM: AuthViewModel
    var store = DataStore.shared

    @State private var donorVM: DonorViewModel
    @State private var requesterVM: RequesterViewModel

    init(user: User, authVM: AuthViewModel) {
        self.user = user
        self.authVM = authVM
        _donorVM = State(initialValue: DonorViewModel(user: user))
        _requesterVM = State(initialValue: RequesterViewModel(user: user))
    }

    var body: some View {
        Group {
            switch user.role {
            case .user: userTabs
            case .hospital: hospitalTabs
            case .admin: adminTabs
            }
        }
        .tint(.bloodRed)
    }

    // MARK: - User Tabs (Donor + Recipient combined)
    private var userTabs: some View {
        TabView {
            UserDashboard(donorVM: donorVM, requesterVM: requesterVM)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NavigationStack {
                DonorHistoryView(donations: store.donations, user: donorVM.currentUser)
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
                ProfileView(user: donorVM.currentUser, onLogout: { authVM.logout() }, onReset: {
                    DataStore.shared.resetForDemo()
                    donorVM.currentUser.lastDonationDate = nil
                    donorVM.currentUser.totalDonations = 3
                    donorVM.isAvailable = true
                })
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

    // MARK: - Admin Tabs
    private var adminTabs: some View {
        TabView {
            AdminDashboard()
                .tabItem {
                    Label("Overview", systemImage: "shield.checkered")
                }

            NavigationStack {
                AdminHospitalListView()
            }
            .tabItem {
                Label("Hospitals", systemImage: "building.2.fill")
            }
            .badge(store.pendingHospitals.count)

            NavigationStack {
                AdminUsersView()
            }
            .tabItem {
                Label("Users", systemImage: "person.2.fill")
            }

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
