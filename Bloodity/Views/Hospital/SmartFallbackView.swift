import SwiftUI

struct SmartFallbackView: View {
    @Bindable var viewModel: HospitalViewModel
    @State private var expandedRadius: Double = 10
    @State private var isExpanding = false

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: BSpacing.xl) {
                    fallbackHeader
                    radiusControl
                    nearbyHospitals
                    bloodBankSection
                }
                .padding(.horizontal).padding(.bottom, 100)
            }
        }
        .navigationTitle("Smart Fallback")
        .navigationBarTitleDisplayMode(.large)
    }

    private var fallbackHeader: some View {
        VStack(spacing: BSpacing.md) {
            ZStack {
                // Expanding radius rings
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(Color.healBlue.opacity(0.15 - Double(i) * 0.04), lineWidth: 1)
                        .frame(width: CGFloat(80 + i * 40), height: CGFloat(80 + i * 40))
                        .scaleEffect(isExpanding ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: isExpanding)
                }
                ZStack {
                    Circle().fill(Color.healBlue.gradient).frame(width: 56, height: 56)
                    Image(systemName: "antenna.radiowaves.left.and.right").font(.system(size: 22)).foregroundColor(.white)
                }
            }
            .frame(height: 180)
            .onAppear { isExpanding = true }

            Text("Expanding Donor Search").font(BFont.title()).foregroundColor(.textPrimary)
            Text("When no donors are found in the initial radius, the system auto-expands and searches partner facilities.")
                .font(BFont.caption()).foregroundColor(.textSecondary).multilineTextAlignment(.center)
        }.padding(BSpacing.lg).glassCard()
    }

    private var radiusControl: some View {
        VStack(spacing: BSpacing.md) {
            HStack {
                Text("Search Radius").font(BFont.headline()).foregroundColor(.textPrimary)
                Spacer()
                Text("\(Int(expandedRadius)) km").font(BFont.headline()).foregroundColor(.healBlue)
            }
            Slider(value: $expandedRadius, in: 5...50, step: 5).tint(.healBlue)
            HStack {
                Text("5 km").font(BFont.caption(11)).foregroundColor(.textSecondary)
                Spacer()
                Text("50 km").font(BFont.caption(11)).foregroundColor(.textSecondary)
            }
        }.padding(BSpacing.lg).glassCard()
    }

    private var nearbyHospitals: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Image(systemName: "building.2.fill").foregroundColor(.healBlue)
                Text("Partner Hospitals").font(BFont.title(20)).foregroundColor(.textPrimary)
            }
            ForEach(MockData.hospitals.filter { $0.id != viewModel.hospital.id }) { hospital in
                hospitalCard(hospital)
            }
        }
    }

    private func hospitalCard(_ hospital: Hospital) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(hospital.name).font(BFont.headline(15)).foregroundColor(.textPrimary)
                    Text(hospital.address).font(BFont.caption()).foregroundColor(.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.1f km", hospital.distance(fromLat: viewModel.hospital.latitude, fromLon: viewModel.hospital.longitude)))
                        .font(BFont.captionBold()).foregroundColor(.healBlue)
                    if hospital.isPartner {
                        Text("Partner").font(BFont.caption(10)).foregroundColor(.successGreen)
                    }
                }
            }
            // Simulated stock levels
            HStack(spacing: 6) {
                ForEach(["A+", "B+", "O+", "AB+"], id: \.self) { type in
                    VStack(spacing: 2) {
                        Text(type).font(.system(size: 10, weight: .bold)).foregroundColor(.textSecondary)
                        Text("\(Int.random(in: 5...30))").font(BFont.captionBold(12)).foregroundColor(.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.surfaceDark))
                }
            }
            Button {} label: {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Request Transfer")
                }.font(BFont.captionBold()).foregroundColor(.healBlue).frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Capsule().fill(Color.healBlue.opacity(0.15)))
            }
        }.padding(BSpacing.lg).glassCard()
    }

    private var bloodBankSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Image(systemName: "cross.case.fill").foregroundColor(.warmAmber)
                Text("Blood Banks").font(BFont.title(20)).foregroundColor(.textPrimary)
            }
            let redCross = MockData.hospitals.last!
            VStack(alignment: .leading, spacing: BSpacing.md) {
                HStack {
                    ZStack {
                        Circle().fill(Color.bloodRed.gradient).frame(width: 44, height: 44)
                        Image(systemName: "cross.fill").font(.system(size: 18)).foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(redCross.name).font(BFont.headline(15)).foregroundColor(.textPrimary)
                        Text(redCross.address).font(BFont.caption()).foregroundColor(.textSecondary)
                    }
                    Spacer()
                    Text(String(format: "%.1f km", redCross.distance(fromLat: viewModel.hospital.latitude, fromLon: viewModel.hospital.longitude)))
                        .font(BFont.captionBold()).foregroundColor(.warmAmber)
                }
                HStack(spacing: BSpacing.md) {
                    Button {} label: {
                        HStack { Image(systemName: "phone.fill"); Text("Call") }
                            .font(BFont.captionBold()).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Capsule().fill(Color.successGreen.gradient))
                    }
                    Button {} label: {
                        HStack { Image(systemName: "map.fill"); Text("Navigate") }
                            .font(BFont.captionBold()).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Capsule().fill(Color.healBlue.gradient))
                    }
                }
            }.padding(BSpacing.lg).glassCard()
        }
    }
}

#Preview { NavigationStack { SmartFallbackView(viewModel: HospitalViewModel(user: MockData.hospitalAccount)) } }
