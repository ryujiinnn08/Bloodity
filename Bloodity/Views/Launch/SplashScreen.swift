import SwiftUI

struct SplashScreen: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var taglineOpacity: Double = 0

    var onComplete: () -> Void

    var body: some View {
        ZStack {
            // Background
            Color.deepNavy.ignoresSafeArea()

            // Animated gradient overlay
            RadialGradient(
                colors: [
                    Color.bloodRed.opacity(0.3),
                    Color.deepNavy
                ],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Logo
                BloodDropLogo(size: 100)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                // App Name
                Text("Bloodity")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .coralPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(textOpacity)

                // Tagline
                Text("Every Drop Saves a Life")
                    .font(BFont.body())
                    .foregroundColor(.textSecondary)
                    .opacity(taglineOpacity)

                Spacer()

                // Loading indicator
                ProgressView()
                    .tint(.coralPink)
                    .opacity(taglineOpacity)
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 0.6).delay(0.6)) {
                textOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 0.6).delay(1.0)) {
                taglineOpacity = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
}

#Preview {
    SplashScreen(onComplete: {})
}
