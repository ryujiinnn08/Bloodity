import SwiftUI

// MARK: - Color Palette (Light Mode)
extension Color {
    // Primary — #D32F2F
    static let bloodRed = Color(red: 0.827, green: 0.184, blue: 0.184)
    static let bloodRedDark = Color(red: 0.60, green: 0.11, blue: 0.11)
    static let coralPink = Color(red: 0.91, green: 0.45, blue: 0.45)

    // Tertiary — #00799C (teal)
    static let healBlue = Color(red: 0.0, green: 0.475, blue: 0.612)
    static let warmAmber = Color(red: 0.96, green: 0.62, blue: 0.04)

    // Backgrounds (Light mode)
    static let deepNavy = Color(red: 0.96, green: 0.96, blue: 0.97)      // Light gray bg
    static let cardDark = Color.white                                       // White cards
    static let surfaceDark = Color(red: 0.93, green: 0.93, blue: 0.94)    // Subtle gray

    // Text (Light mode)
    static let textPrimary = Color(red: 0.12, green: 0.12, blue: 0.13)    // Near-black
    static let textSecondary = Color(red: 0.537, green: 0.447, blue: 0.435) // #89726F neutral

    // Status
    static let successGreen = Color(red: 0.06, green: 0.73, blue: 0.51)
    static let warningOrange = Color(red: 0.96, green: 0.62, blue: 0.04)

    // Header gradient
    static let headerDark = Color(red: 0.35, green: 0.10, blue: 0.10)
    static let headerMid = Color(red: 0.55, green: 0.15, blue: 0.15)
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let bloodGradient = LinearGradient(
        colors: [.bloodRed, .bloodRedDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let headerGradient = LinearGradient(
        colors: [Color(red: 0.35, green: 0.08, blue: 0.08), .bloodRed],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let darkCardGradient = LinearGradient(
        colors: [.cardDark, .cardDark.opacity(0.95)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradient = LinearGradient(
        colors: [.bloodRed, .coralPink.opacity(0.6)],
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
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
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
                RoundedRectangle(cornerRadius: BRadius.md)
                    .fill(Color.bloodRed)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
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
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
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
    case donorArrived = "Donor Arrived"
    case fulfilled = "Fulfilled"
    case expired = "Expired"

    var color: Color {
        switch self {
        case .searching: return .warmAmber
        case .donorFound: return .healBlue
        case .onTheWay: return .coralPink
        case .donorArrived: return .successGreen
        case .fulfilled: return .successGreen
        case .expired: return .textSecondary
        }
    }

    var icon: String {
        switch self {
        case .searching: return "magnifyingglass"
        case .donorFound: return "person.fill.checkmark"
        case .onTheWay: return "figure.walk"
        case .donorArrived: return "building.2.fill"
        case .fulfilled: return "checkmark.circle.fill"
        case .expired: return "clock.badge.xmark"
        }
    }
}

enum UserRole: String, CaseIterable, Codable {
    case user = "User"
    case hospital = "Hospital"
    case admin = "Admin"

    var icon: String {
        switch self {
        case .user: return "person.fill"
        case .hospital: return "cross.case.fill"
        case .admin: return "shield.checkered"
        }
    }

    var color: Color {
        switch self {
        case .user: return .bloodRed
        case .hospital: return .healBlue
        case .admin: return .warmAmber
        }
    }

    /// Roles available in registration (admin is not self-registrable)
    static var registrableRoles: [UserRole] {
        [.user, .hospital]
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
