import SwiftUI

struct SmartFallbackView: View {
    @Bindable var viewModel: HospitalViewModel
    @State private var expandedRadius: Double = 10
    @State private var isExpanding = false
    @State private var requestTarget: RequestTarget?

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(spacing: BSpacing.xl) {
                    fallbackHeader
                    radiusControl
                    nearbyHospitals
                    bloodBankSection
                }
                .padding(.horizontal).padding(.bottom, 100)
            }
        }
        .navigationTitle("Sourcing Cascade")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $requestTarget) { target in
            BloodRequestSheet(viewModel: viewModel, target: target)
        }
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

            Text("Sourcing Cascade").font(BFont.title()).foregroundColor(.textPrimary)
            Text("When stock is low, request blood from partner hospitals or the Red Cross. Tap \"Send Request\" to initiate.")
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
            ForEach(MockData.hospitals.filter { $0.id != viewModel.hospital.id && $0.isPartner }) { hospital in
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
            Button {
                requestTarget = .hospital(hospital)
            } label: {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Send Request")
                }.font(BFont.captionBold()).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(Capsule().fill(Color.healBlue.gradient))
            }
        }.padding(BSpacing.lg).glassCard()
    }

    private var bloodBankSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            HStack {
                Image(systemName: "cross.case.fill").foregroundColor(.warmAmber)
                Text("Blood Banks").font(BFont.title(20)).foregroundColor(.textPrimary)
            }
            let redCross = MockData.hospitals.first(where: { $0.name.contains("Red Cross") }) ?? MockData.hospitals.last!
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

                Button {
                    requestTarget = .redCross(redCross)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                        Text("Send Request")
                    }
                    .font(BFont.captionBold()).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(Capsule().fill(LinearGradient.bloodGradient))
                }
            }.padding(BSpacing.lg).glassCard()
        }
    }
}

// MARK: - Request Target
enum RequestTarget: Identifiable {
    case hospital(Hospital)
    case redCross(Hospital)

    var id: UUID {
        switch self {
        case .hospital(let h): return h.id
        case .redCross(let h): return h.id
        }
    }

    var name: String {
        switch self {
        case .hospital(let h): return h.name
        case .redCross(let h): return h.name
        }
    }

    var isRedCross: Bool {
        if case .redCross = self { return true }
        return false
    }
}

// MARK: - Blood Request Sheet
struct BloodRequestSheet: View {
    @Bindable var viewModel: HospitalViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTarget: RequestTarget
    @State private var selectedBloodType: BloodType = .oPositive
    @State private var unitsNeeded: Int = 1
    @State private var urgencyLevel: UrgencyLevel = .urgent
    @State private var notes: String = ""
    @State private var showConfirmation = false
    @State private var showHospitalPicker = false

    init(viewModel: HospitalViewModel, target: RequestTarget) {
        self.viewModel = viewModel
        self._selectedTarget = State(initialValue: target)
    }

    private var partnerHospitals: [Hospital] {
        MockData.hospitals.filter { $0.isPartner && $0.id != viewModel.hospital.id }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                if showConfirmation {
                    confirmationView
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                } else {
                    requestForm
                }
            }
            .navigationTitle("Request Blood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Request Form
    private var requestForm: some View {
        ScrollView(.vertical) {
            VStack(spacing: BSpacing.xl) {
                // Target Info
                targetHeader

                // Hospital Picker (expandable)
                if showHospitalPicker && !selectedTarget.isRedCross {
                    hospitalPickerSection
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // Blood Type Selection
                bloodTypeSection

                // Units Needed
                unitsSection

                // Urgency Level
                urgencySection

                // Notes
                notesSection

                // Submit Button
                submitButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Target Header
    private var targetHeader: some View {
        Button {
            if !selectedTarget.isRedCross {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showHospitalPicker.toggle()
                }
            }
        } label: {
            HStack(spacing: BSpacing.md) {
                ZStack {
                    Circle()
                        .fill(selectedTarget.isRedCross ? Color.bloodRed.gradient : Color.healBlue.gradient)
                        .frame(width: 48, height: 48)

                    Image(systemName: selectedTarget.isRedCross ? "cross.fill" : "building.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Requesting from")
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary)

                    Text(selectedTarget.name)
                        .font(BFont.headline())
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                }

                Spacer()

                if !selectedTarget.isRedCross {
                    HStack(spacing: 4) {
                        Text("Change")
                            .font(BFont.caption(11))
                            .foregroundColor(.healBlue)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.healBlue)
                            .rotationEffect(.degrees(showHospitalPicker ? 180 : 0))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.healBlue.opacity(0.1))
                    )
                }
            }
            .padding(BSpacing.lg)
            .glassCard()
            .overlay(
                RoundedRectangle(cornerRadius: BRadius.lg)
                    .stroke(showHospitalPicker ? Color.healBlue.opacity(0.3) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showHospitalPicker)
    }

    // MARK: - Hospital Picker
    private var hospitalPickerSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.sm) {
            Text("Select Partner Hospital")
                .font(BFont.captionBold())
                .foregroundColor(.textSecondary)
                .padding(.horizontal, BSpacing.xs)

            ForEach(partnerHospitals) { hospital in
                let isSelected = selectedTarget.id == hospital.id
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTarget = .hospital(hospital)
                        showHospitalPicker = false
                    }
                } label: {
                    HStack(spacing: BSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(isSelected ? Color.healBlue.gradient : Color.surfaceDark.gradient)
                                .frame(width: 36, height: 36)

                            Image(systemName: isSelected ? "checkmark" : "building.2.fill")
                                .font(.system(size: 13, weight: isSelected ? .bold : .regular))
                                .foregroundColor(isSelected ? .white : .textSecondary)
                        }

                        VStack(alignment: .leading, spacing: 1) {
                            Text(hospital.name)
                                .font(BFont.captionBold(13))
                                .foregroundColor(isSelected ? .healBlue : .textPrimary)
                                .lineLimit(1)

                            Text(hospital.address)
                                .font(BFont.caption(11))
                                .foregroundColor(.textSecondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        Text(String(format: "%.1f km", hospital.distance(fromLat: viewModel.hospital.latitude, fromLon: viewModel.hospital.longitude)))
                            .font(BFont.captionBold(11))
                            .foregroundColor(.healBlue)
                    }
                    .padding(BSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .fill(isSelected ? Color.healBlue.opacity(0.08) : Color.cardDark)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .stroke(isSelected ? Color.healBlue.opacity(0.3) : Color.black.opacity(0.06), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Blood Type
    private var bloodTypeSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Label("Blood Type Needed", systemImage: "drop.fill")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: BSpacing.sm) {
                ForEach(BloodType.allCases) { type in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedBloodType = type
                        }
                    } label: {
                        Text(type.rawValue)
                            .font(BFont.captionBold(14))
                            .foregroundColor(selectedBloodType == type ? .white : .textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: BRadius.md)
                                    .fill(selectedBloodType == type ? type.color.gradient : Color.surfaceDark.gradient)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: BRadius.md)
                                    .stroke(selectedBloodType == type ? Color.clear : Color.black.opacity(0.06), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Units
    private var unitsSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Label("Units Required", systemImage: "number")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            HStack(spacing: BSpacing.xl) {
                Button {
                    if unitsNeeded > 1 {
                        withAnimation(.spring(response: 0.3)) { unitsNeeded -= 1 }
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(unitsNeeded > 1 ? .bloodRed : .textSecondary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(unitsNeeded > 1 ? Color.bloodRed.opacity(0.1) : Color.surfaceDark)
                        )
                }

                VStack(spacing: 2) {
                    Text("\(unitsNeeded)")
                        .font(BFont.metric(36))
                        .foregroundColor(.textPrimary)
                        .contentTransition(.numericText())

                    Text("unit\(unitsNeeded > 1 ? "s" : "")")
                        .font(BFont.caption())
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)

                Button {
                    if unitsNeeded < 20 {
                        withAnimation(.spring(response: 0.3)) { unitsNeeded += 1 }
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.bloodRed)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.bloodRed.opacity(0.1))
                        )
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Urgency
    private var urgencySection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Label("Urgency Level", systemImage: "exclamationmark.triangle.fill")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            HStack(spacing: BSpacing.sm) {
                ForEach(UrgencyLevel.allCases, id: \.rawValue) { level in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            urgencyLevel = level
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: level.icon)
                                .font(.system(size: 16))
                            Text(level.rawValue)
                                .font(BFont.captionBold(12))
                        }
                        .foregroundColor(urgencyLevel == level ? .white : level.color)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.md)
                                .fill(urgencyLevel == level ? level.color.gradient : level.color.opacity(0.1).gradient)
                        )
                    }
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Notes
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Label("Additional Notes", systemImage: "text.alignleft")
                .font(BFont.headline())
                .foregroundColor(.textPrimary)

            TextField("", text: $notes, prompt: Text("Optional — e.g. patient condition, pickup time...").foregroundColor(.textSecondary.opacity(0.5)), axis: .vertical)
                .font(BFont.body())
                .foregroundColor(.textPrimary)
                .lineLimit(3...5)
                .padding(BSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .fill(Color.surfaceDark)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    // MARK: - Submit
    private var submitButton: some View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showConfirmation = true
            }

            // Generate notification in DataStore
            let notification = AppNotification(
                id: UUID(),
                title: "Blood Request Sent",
                message: "Requested \(unitsNeeded) unit\(unitsNeeded > 1 ? "s" : "") of \(selectedBloodType.rawValue) from \(selectedTarget.name). Urgency: \(urgencyLevel.rawValue).",
                type: .newRequest,
                isRead: false,
                timestamp: Date()
            )
            viewModel.store.hospitalNotifications.insert(notification, at: 0)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 15))
                Text("Send Blood Request")
                    .font(BFont.headline())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: BRadius.md)
                    .fill(LinearGradient.bloodGradient)
            )
        }
    }

    // MARK: - Confirmation
    private var confirmationView: some View {
        VStack(spacing: BSpacing.xxl) {
            Spacer()

            // Animated checkmark
            ZStack {
                Circle()
                    .fill(Color.successGreen.opacity(0.1))
                    .frame(width: 120, height: 120)

                Circle()
                    .fill(Color.successGreen.opacity(0.2))
                    .frame(width: 90, height: 90)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.successGreen)
            }

            VStack(spacing: BSpacing.sm) {
                Text("Request Sent!")
                    .font(BFont.title())
                    .foregroundColor(.textPrimary)

                Text("\(unitsNeeded) unit\(unitsNeeded > 1 ? "s" : "") of \(selectedBloodType.rawValue) requested from \(selectedTarget.name)")
                    .font(BFont.body())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BSpacing.xxl)
            }

            // Summary Card
            VStack(spacing: BSpacing.md) {
                summaryRow(icon: "drop.fill", label: "Blood Type", value: selectedBloodType.rawValue, color: selectedBloodType.color)
                Divider().background(Color.black.opacity(0.06))
                summaryRow(icon: "number", label: "Units", value: "\(unitsNeeded)", color: .healBlue)
                Divider().background(Color.black.opacity(0.06))
                summaryRow(icon: "exclamationmark.triangle.fill", label: "Urgency", value: urgencyLevel.rawValue, color: urgencyLevel.color)
                if !notes.isEmpty {
                    Divider().background(Color.black.opacity(0.06))
                    summaryRow(icon: "text.alignleft", label: "Notes", value: notes, color: .textSecondary)
                }
            }
            .padding(BSpacing.lg)
            .glassCard()
            .padding(.horizontal)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(BFont.headline())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .fill(Color.successGreen.gradient)
                    )
            }
            .padding(.horizontal)
            .padding(.bottom, BSpacing.xxl)
        }
    }

    private func summaryRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: BSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 24)

            Text(label)
                .font(BFont.caption())
                .foregroundColor(.textSecondary)

            Spacer()

            Text(value)
                .font(BFont.captionBold())
                .foregroundColor(.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview { NavigationStack { SmartFallbackView(viewModel: HospitalViewModel(user: MockData.hospitalAccount)) } }
