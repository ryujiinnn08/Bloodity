import SwiftUI

@main
struct BloodityApp: App {
    @State private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if authVM.isShowingSplash {
                    SplashScreen {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            authVM.isShowingSplash = false
                        }
                    }
                } else if authVM.isAuthenticated, let user = authVM.currentUser {
                    MainTabView(user: user, authVM: authVM)
                        .transition(.opacity)
                } else {
                    LoginView(authVM: authVM)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: authVM.isAuthenticated)
            .animation(.easeInOut(duration: 0.4), value: authVM.isShowingSplash)
            .preferredColorScheme(.dark)
        }
    }
}
