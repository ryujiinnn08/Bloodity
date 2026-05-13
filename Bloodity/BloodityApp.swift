import SwiftUI

@main
struct BloodityApp: App {
    @State private var authVM = AuthViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if authVM.isShowingSplash {
                    SplashScreen {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            authVM.isShowingSplash = false
                        }
                    }
                } else if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .transition(.opacity)
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
            .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
            .preferredColorScheme(.light)
        }
    }
}
