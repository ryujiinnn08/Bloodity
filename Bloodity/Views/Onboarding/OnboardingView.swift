import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var agreedToTerms = false

    private let totalPages = 3

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentPage) {
                // Page 1 — Welcome
                onboardingPage(
                    imageName: "Onboarding1",
                    title: "Welcome to Bloodity",
                    description: "Bloodity is an AI-powered blood stock forecasting and donor matching system that connects donors, recipients, and hospitals in real time — saving lives across the Philippines."
                )
                .tag(0)

                // Page 2 — Location-Aware Alerts
                onboardingPage(
                    imageName: "Onboarding2",
                    title: "Location-Aware Alerts",
                    description: "Receive instant notifications when a nearby hospital urgently needs your blood type. Our smart matching system ranks compatible donors by proximity and availability."
                )
                .tag(1)

                // Page 3 — Terms & Conditions
                termsPage
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: currentPage)
            .ignoresSafeArea()

            // Bottom overlay: dots + button
            VStack {
                Spacer()

                VStack(spacing: BSpacing.lg) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }

                    // Next / Get Started button
                    Button {
                        if currentPage < totalPages - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.spring(response: 0.5)) {
                                hasCompletedOnboarding = true
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(currentPage == totalPages - 1 ? "Get Started" : "Next")
                                .font(BFont.headline())
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.bloodRed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.md)
                                .fill(Color.white)
                        )
                    }
                    .disabled(currentPage == totalPages - 1 && !agreedToTerms)
                    .opacity(currentPage == totalPages - 1 && !agreedToTerms ? 0.5 : 1.0)
                    .padding(.horizontal, BSpacing.xxxl)
                }
                .padding(.bottom, 50)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Onboarding Page (Image-based)
    private func onboardingPage(imageName: String, title: String, description: String) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Full-screen image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height * 0.65)
                    .clipped()
                    .frame(maxHeight: .infinity, alignment: .top)

                // Bottom red curve with text
                VStack(spacing: 0) {
                    // Curved top edge
                    WaveShape()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.45, green: 0.08, blue: 0.08),
                                    Color(red: 0.30, green: 0.05, blue: 0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 50)

                    // Content area
                    VStack(spacing: BSpacing.lg) {
                        Text(title)
                            .font(BFont.display(26))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text(description)
                            .font(BFont.body(14))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, BSpacing.xxl)
                    .padding(.top, BSpacing.md)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.30, green: 0.05, blue: 0.05),
                                Color(red: 0.15, green: 0.02, blue: 0.02)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    // Spacer for button area
                    Color(red: 0.15, green: 0.02, blue: 0.02)
                        .frame(height: 140)
                }
                .frame(height: geo.size.height * 0.42)
            }
        }
    }

    // MARK: - Terms & Conditions Page
    private var termsPage: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Maroon gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.50, green: 0.08, blue: 0.10),
                        Color(red: 0.30, green: 0.04, blue: 0.06),
                        Color(red: 0.15, green: 0.02, blue: 0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 40)

                    // Terms card
                    VStack(alignment: .leading, spacing: BSpacing.xl) {
                        termsItem(
                            title: "Platform for Connection",
                            description: "Bloodity connects blood donors with recipients and hospitals. We facilitate the matching process but do not provide medical services directly."
                        )

                        termsItem(
                            title: "Data Privacy",
                            description: "Your personal and medical data is protected under R.A. 10173 (Data Privacy Act of 2012). We collect only essential information for donor matching."
                        )

                        termsItem(
                            title: "Safety & Verification",
                            description: "All donors must meet WHO eligibility criteria including the 56-day interval between donations. Blood type verification is the responsibility of the hospital."
                        )

                        termsItem(
                            title: "Community Conduct",
                            description: "Users must provide accurate information. Misuse of the platform, including false requests or impersonation, may result in account suspension."
                        )
                    }
                    .padding(BSpacing.xl)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.xl)
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: BRadius.xl)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, BSpacing.lg)

                    Spacer()

                    // Agreement toggle
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            agreedToTerms.toggle()
                        }
                    } label: {
                        HStack(spacing: BSpacing.md) {
                            Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                .font(.system(size: 22))
                                .foregroundColor(agreedToTerms ? .white : .white.opacity(0.5))

                            Text("I agree to the Terms and Conditions")
                                .font(BFont.body(14))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal, BSpacing.xxl)

                    // Title
                    VStack(spacing: BSpacing.sm) {
                        Text("Terms and Conditions")
                            .font(BFont.display(26))
                            .foregroundColor(.white)

                        Text("Please read and accept to continue")
                            .font(BFont.body(14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, BSpacing.xl)

                    // Spacer for button area
                    Spacer()
                        .frame(height: 140)
                }
            }
        }
    }

    // MARK: - Terms Item
    private func termsItem(title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: BSpacing.md) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 12))
                .foregroundColor(.bloodRed)
                .padding(.top, 3)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFont.headline(15))
                    .foregroundColor(.white)

                Text(description)
                    .font(BFont.caption(12))
                    .foregroundColor(.white.opacity(0.7))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.5),
            control: CGPoint(x: rect.width * 0.5, y: -rect.height * 0.3)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
