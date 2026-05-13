import SwiftUI

// MARK: - Color Palette
extension Color {
    // Primary
    static let bloodRed = Color(red: 0.86, green: 0.15, blue: 0.15)       // #DC2626
    static let bloodRedDark = Color(red: 0.60, green: 0.11, blue: 0.11)   // #991B1B
    static let coralPink = Color(red: 0.98, green: 0.44, blue: 0.52)      // #FB7185

    // Urgency
    static let warmAmber = Color(red: 0.96, green: 0.62, blue: 0.04)      // #F59E0B
    static let healBlue = Color(red: 0.23, green: 0.51, blue: 0.96)       // #3B82F6

    // Backgrounds
    static let deepNavy = Color(red: 0.06, green: 0.09, blue: 0.16)       // #0F172A
    static let cardDark = Color(red: 0.12, green: 0.16, blue: 0.23)       // #1E293B
    static let surfaceDark = Color(red: 0.20, green: 0.25, blue: 0.33)    // #334155

    // Text
    static let textPrimary = Color(red: 0.97, green: 0.98, blue: 0.99)    // #F8FAFC
    static let textSecondary = Color(red: 0.58, green: 0.64, blue: 0.72)  // #94A3B8

    // Status
    static let successGreen = Color(red: 0.06, green: 0.73, blue: 0.51)   // #10B981
    static let warningOrange = Color(red: 0.96, green: 0.62, blue: 0.04)  // #F59E0B

    // Gradients
    static let bloodGradientStart = Color(red: 0.86, green: 0.15, blue: 0.15)
    static let bloodGradientEnd = Color(red: 0.98, green: 0.44, blue: 0.52)
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let bloodGradient = LinearGradient(
        colors: [.bloodRed, .coralPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let darkCardGradient = LinearGradient(
        colors: [.cardDark, .cardDark.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradient = LinearGradient(
        colors: [
            Color.bloodRed.opacity(0.6),
            Color.coralPink.opacity(0.3),
            Color.deepNavy
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography
struct BFont {
    static func display(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func title(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func headline(_ size: CGFloat = 17) -> Font {
        .system(size: size, weight: .semibold)
    }

    static func body(_ size: CGFloat = 15) -> Font {
        .system(size: size, weight: .regular)
    }

    static func caption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .regular)
    }

    static func captionBold(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .semibold)
    }

    static func metric(_ size: CGFloat = 32) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
}

// MARK: - Spacing
struct BSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
}

// MARK: - Corner Radius
struct BRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let full: CGFloat = 100
}

// MARK: - View Modifiers
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = BRadius.lg

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.cardDark.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFont.headline())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                LinearGradient.bloodGradient
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .cornerRadius(BRadius.md)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFont.headline())
            .foregroundColor(.bloodRed)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: BRadius.md)
                    .stroke(Color.bloodRed, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
    }
}

// MARK: - View Extensions
extension View {
    func glassCard(cornerRadius: CGFloat = BRadius.lg) -> some View {
        self.modifier(GlassCard(cornerRadius: cornerRadius))
    }

    func cardShadow() -> some View {
        self.modifier(CardShadow())
    }
}

// MARK: - Blood Type Helpers
enum BloodType: String, CaseIterable, Codable, Identifiable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case abPositive = "AB+"
    case abNegative = "AB-"
    case oPositive = "O+"
    case oNegative = "O-"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .aPositive, .aNegative: return .bloodRed
        case .bPositive, .bNegative: return .healBlue
        case .abPositive, .abNegative: return .coralPink
        case .oPositive, .oNegative: return .successGreen
        }
    }

    var compatibleDonors: [BloodType] {
        switch self {
        case .abPositive: return BloodType.allCases
        case .abNegative: return [.abNegative, .aNegative, .bNegative, .oNegative]
        case .aPositive: return [.aPositive, .aNegative, .oPositive, .oNegative]
        case .aNegative: return [.aNegative, .oNegative]
        case .bPositive: return [.bPositive, .bNegative, .oPositive, .oNegative]
        case .bNegative: return [.bNegative, .oNegative]
        case .oPositive: return [.oPositive, .oNegative]
        case .oNegative: return [.oNegative]
        }
    }
}

enum UrgencyLevel: String, CaseIterable, Codable {
    case critical = "Critical"
    case urgent = "Urgent"
    case standard = "Standard"

    var color: Color {
        switch self {
        case .critical: return .bloodRed
        case .urgent: return .warmAmber
        case .standard: return .healBlue
        }
    }

    var icon: String {
        switch self {
        case .critical: return "exclamationmark.triangle.fill"
        case .urgent: return "exclamationmark.circle.fill"
        case .standard: return "info.circle.fill"
        }
    }
}

enum RequestStatus: String, CaseIterable, Codable {
    case searching = "Searching"
    case donorFound = "Donor Found"
    case onTheWay = "On the Way"
    case fulfilled = "Fulfilled"
    case expired = "Expired"

    var color: Color {
        switch self {
        case .searching: return .warmAmber
        case .donorFound: return .healBlue
        case .onTheWay: return .coralPink
        case .fulfilled: return .successGreen
        case .expired: return .textSecondary
        }
    }

    var icon: String {
        switch self {
        case .searching: return "magnifyingglass"
        case .donorFound: return "person.fill.checkmark"
        case .onTheWay: return "figure.walk"
        case .fulfilled: return "checkmark.circle.fill"
        case .expired: return "clock.badge.xmark"
        }
    }
}

enum UserRole: String, CaseIterable, Codable {
    case donor = "Donor"
    case requester = "Requester"
    case hospital = "Hospital"

    var icon: String {
        switch self {
        case .donor: return "drop.fill"
        case .requester: return "heart.fill"
        case .hospital: return "cross.case.fill"
        }
    }

    var color: Color {
        switch self {
        case .donor: return .bloodRed
        case .requester: return .coralPink
        case .hospital: return .healBlue
        }
    }
}

enum PredictionSeverity: String, Codable {
    case watch = "Watch"
    case warning = "Warning"
    case critical = "Critical"

    var color: Color {
        switch self {
        case .watch: return .warmAmber
        case .warning: return .warningOrange
        case .critical: return .bloodRed
        }
    }

    var icon: String {
        switch self {
        case .watch: return "eye.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "bolt.trianglebadge.exclamationmark.fill"
        }
    }
}
