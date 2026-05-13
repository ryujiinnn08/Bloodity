import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false

    var colors: [Color] = [.bloodRed, .coralPink, .bloodRedDark]

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct PulsingDot: View {
    let color: Color
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: 20, height: 20)
                .scaleEffect(isPulsing ? 1.5 : 1.0)
                .opacity(isPulsing ? 0 : 0.6)

            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                isPulsing = true
            }
        }
    }
}

struct BloodDropLogo: View {
    @State private var isAnimating = false

    var size: CGFloat = 60

    var body: some View {
        ZStack {
            // Outer glow
            Image(systemName: "drop.fill")
                .font(.system(size: size * 0.9))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.bloodRed.opacity(0.4), .coralPink.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .blur(radius: 10)
                .scaleEffect(isAnimating ? 1.15 : 1.0)

            // Main drop
            Image(systemName: "drop.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.bloodRed, .coralPink],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .bloodRed.opacity(0.5), radius: 8, y: 4)

            // Heart inside
            Image(systemName: "heart.fill")
                .font(.system(size: size * 0.28))
                .foregroundColor(.white.opacity(0.9))
                .offset(y: size * 0.06)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.1),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    phase = 200
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
}

#Preview {
    ZStack {
        Color.deepNavy.ignoresSafeArea()
        VStack(spacing: 30) {
            BloodDropLogo(size: 80)
            PulsingDot(color: .successGreen)
            PulsingDot(color: .bloodRed)
        }
    }
}
