import SwiftUI
import MapKit

struct DonorNavigationView: View {
    let request: BloodRequest
    let donor: User
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var progress: Double = 0
    @State private var isNavigating = false
    @State private var showArrived = false
    @State private var etaMinutes: Int = 0

    // Route coordinates
    private var donorCoord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: donor.latitude, longitude: donor.longitude)
    }

    private var hospitalCoord: CLLocationCoordinate2D {
        let hospital = DataStore.shared.hospitals.first(where: { $0.id == request.hospitalId })
        return CLLocationCoordinate2D(
            latitude: hospital?.latitude ?? 14.5764,
            longitude: hospital?.longitude ?? 120.9842
        )
    }

    // Interpolated route points for smooth animation
    private var routePoints: [CLLocationCoordinate2D] {
        let steps = 50
        return (0...steps).map { i in
            let t = Double(i) / Double(steps)
            return CLLocationCoordinate2D(
                latitude: donorCoord.latitude + (hospitalCoord.latitude - donorCoord.latitude) * t,
                longitude: donorCoord.longitude + (hospitalCoord.longitude - donorCoord.longitude) * t
            )
        }
    }

    private var currentPosition: CLLocationCoordinate2D {
        let idx = min(Int(progress * Double(routePoints.count - 1)), routePoints.count - 1)
        return routePoints[idx]
    }

    private var distanceKm: Double {
        donor.distance(to: hospitalCoord.latitude, hospitalCoord.longitude)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Map
            Map {
                // Route polyline
                MapPolyline(coordinates: routePoints)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))

                // Donor marker (animated along route)
                Annotation("You", coordinate: currentPosition) {
                    ZStack {
                        Circle()
                            .fill(Color.bloodRed)
                            .frame(width: 32, height: 32)
                        Image(systemName: "car.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .shadow(color: .bloodRed.opacity(0.4), radius: 6)
                }

                // Hospital marker
                Annotation(request.hospitalName, coordinate: hospitalCoord) {
                    ZStack {
                        Circle()
                            .fill(Color.healBlue)
                            .frame(width: 36, height: 36)
                        Image(systemName: "cross.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .shadow(color: .healBlue.opacity(0.4), radius: 6)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea(edges: .top)

            // Bottom panel
            VStack(spacing: 0) {
                if showArrived {
                    arrivedPanel
                } else {
                    navigationPanel
                }
            }
        }
        .onAppear {
            etaMinutes = Int(distanceKm * 3 + 5)
            startNavigation()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(BFont.body(14))
                    .foregroundColor(.bloodRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.15), radius: 4)
                    )
                }
            }
        }
    }

    // MARK: - Navigation Panel
    private var navigationPanel: some View {
        VStack(spacing: BSpacing.lg) {
            // Progress bar
            VStack(spacing: BSpacing.sm) {
                HStack {
                    Text("Navigating to Hospital")
                        .font(BFont.headline(15))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(BFont.captionBold())
                        .foregroundColor(.bloodRed)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.surfaceDark)
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [.bloodRed, .coralPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)
            }

            // Info row
            HStack(spacing: 0) {
                infoCol(icon: "building.2.fill", value: request.hospitalName, label: "Destination", color: .healBlue)
                Divider().frame(height: 40)
                infoCol(icon: "clock.fill", value: "\(max(1, etaMinutes - Int(Double(etaMinutes) * progress))) min", label: "ETA", color: .warmAmber)
                Divider().frame(height: 40)
                infoCol(icon: "location.fill", value: String(format: "%.1f km", distanceKm * (1 - progress)), label: "Remaining", color: .healBlue)
            }

            // Request badge
            HStack(spacing: BSpacing.sm) {
                BloodTypeBadge(bloodType: request.bloodTypeNeeded, size: .small)
                Text("\(request.unitsNeeded) unit\(request.unitsNeeded > 1 ? "s" : "") for \(request.patientName)")
                    .font(BFont.caption(12))
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(request.urgencyLevel.rawValue)
                    .font(BFont.captionBold(11))
                    .foregroundColor(request.urgencyLevel.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(request.urgencyLevel.color.opacity(0.12)))
            }
        }
        .padding(BSpacing.xl)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: BRadius.xl, topTrailingRadius: BRadius.xl)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -4)
        )
    }

    // MARK: - Arrived Panel
    private var arrivedPanel: some View {
        VStack(spacing: BSpacing.lg) {
            ZStack {
                Circle()
                    .fill(Color.successGreen.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.successGreen)
            }

            Text("You've Arrived!")
                .font(BFont.title(22))
                .foregroundColor(.textPrimary)

            Text("Proceed to \(request.ward) at \(request.hospitalName)")
                .font(BFont.body(14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)

            Button {
                onComplete()
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Confirm Arrival")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(BSpacing.xl)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: BRadius.xl, topTrailingRadius: BRadius.xl)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -4)
        )
    }

    private func infoCol(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            Text(value)
                .font(BFont.captionBold(12))
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(BFont.caption(10))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Simulation Timer
    private func startNavigation() {
        isNavigating = true
        // Simulate ~12 seconds of travel
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            withAnimation(.linear(duration: 0.25)) {
                progress += 0.02
            }
            if progress >= 1.0 {
                timer.invalidate()
                withAnimation(.spring(response: 0.5)) {
                    showArrived = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DonorNavigationView(
            request: MockData.bloodRequests[0],
            donor: MockData.userAccount,
            onComplete: {}
        )
    }
}
