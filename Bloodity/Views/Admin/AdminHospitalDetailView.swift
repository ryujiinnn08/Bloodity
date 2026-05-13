import SwiftUI

struct AdminHospitalDetailView: View {
    let hospital: Hospital
    var store = DataStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: BSpacing.lg) {
                    // Header Card
                    headerCard

                    // Status Badge
                    statusCard

                    // Contact & Location
                    infoCard

                    // Legal Compliance
                    legalCard

                    // Actions (for pending hospitals)
                    if !hospital.isVerified {
                        actionButtons
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Hospital Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header
    private var headerCard: some View {
        VStack(spacing: BSpacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: hospital.isVerified
                                ? [Color.healBlue.opacity(0.2), Color.healBlue.opacity(0.08)]
                                : [Color.warmAmber.opacity(0.2), Color.warmAmber.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "building.2.fill")
                    .font(.system(size: 32))
                    .foregroundColor(hospital.isVerified ? .healBlue : .warmAmber)
            }

            VStack(spacing: 4) {
                Text(hospital.name)
                    .font(BFont.title(22))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text(hospital.shortName)
                    .font(BFont.captionBold())
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.surfaceDark)
                    )
            }
        }
        .padding(.vertical, BSpacing.xl)
        .frame(maxWidth: .infinity)
        .glassCard()
    }

    // MARK: - Status
    private var statusCard: some View {
        HStack(spacing: 0) {
            statusCol(
                label: "Verification",
                value: hospital.isVerified ? "Verified" : "Pending",
                icon: hospital.isVerified ? "checkmark.shield.fill" : "clock.fill",
                color: hospital.isVerified ? .successGreen : .warmAmber
            )

            Divider().frame(height: 40)

            statusCol(
                label: "Partnership",
                value: hospital.isPartner ? "Active" : "Inactive",
                icon: hospital.isPartner ? "handshake.fill" : "xmark.circle",
                color: hospital.isPartner ? .healBlue : .textSecondary
            )

            Divider().frame(height: 40)

            statusCol(
                label: "Agreement",
                value: hospital.partnershipSignedDate != nil ? "Signed" : "Unsigned",
                icon: hospital.partnershipSignedDate != nil ? "signature" : "doc.questionmark",
                color: hospital.partnershipSignedDate != nil ? .successGreen : .bloodRed
            )
        }
        .padding(.vertical, BSpacing.lg)
        .glassCard()
    }

    private func statusCol(label: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            Text(value)
                .font(BFont.captionBold(12))
                .foregroundColor(color)
            Text(label)
                .font(BFont.caption(10))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Contact & Location
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: BSpacing.lg) {
            Text("CONTACT & LOCATION")
                .font(BFont.captionBold(12))
                .foregroundColor(.textSecondary)
                .tracking(0.5)

            infoRow(icon: "mappin.circle.fill", label: "Address", value: hospital.address, color: .bloodRed)
            infoRow(icon: "phone.circle.fill", label: "Contact", value: hospital.contactNumber, color: .healBlue)
            infoRow(icon: "globe", label: "Coordinates", value: String(format: "%.4f, %.4f", hospital.latitude, hospital.longitude), color: .textSecondary)
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    private func infoRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: BSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(BFont.caption(11))
                    .foregroundColor(.textSecondary)
                Text(value)
                    .font(BFont.body(14))
                    .foregroundColor(.textPrimary)
            }

            Spacer()
        }
    }

    // MARK: - Legal Compliance
    private var legalCard: some View {
        VStack(alignment: .leading, spacing: BSpacing.lg) {
            Text("LEGAL COMPLIANCE")
                .font(BFont.captionBold(12))
                .foregroundColor(.textSecondary)
                .tracking(0.5)

            // License
            VStack(alignment: .leading, spacing: BSpacing.sm) {
                HStack(spacing: BSpacing.sm) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 16))
                        .foregroundColor(hospital.licenseNumber.isEmpty ? .bloodRed : .successGreen)

                    Text("DOH License / Accreditation")
                        .font(BFont.captionBold(13))
                        .foregroundColor(.textPrimary)
                }

                if hospital.licenseNumber.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.bloodRed)
                        Text("No license number provided")
                            .font(BFont.caption(12))
                            .foregroundColor(.bloodRed)
                    }
                } else {
                    Text(hospital.licenseNumber)
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundColor(.textPrimary)
                        .padding(BSpacing.sm)
                        .padding(.horizontal, BSpacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.sm)
                                .fill(Color.surfaceDark)
                        )
                }
            }

            Divider()

            // Digital Partnership Agreement
            VStack(alignment: .leading, spacing: BSpacing.sm) {
                HStack(spacing: BSpacing.sm) {
                    Image(systemName: "signature")
                        .font(.system(size: 16))
                        .foregroundColor(hospital.partnershipSignedDate != nil ? .successGreen : .bloodRed)

                    Text("Digital Partnership Agreement")
                        .font(BFont.captionBold(13))
                        .foregroundColor(.textPrimary)
                }

                if let signedDate = hospital.partnershipSignedDate {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.successGreen)
                        Text("Digitally signed on \(signedDate, format: .dateTime.month(.wide).day().year().hour().minute())")
                            .font(BFont.caption(12))
                            .foregroundColor(.successGreen)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        agreementItem("Maintain real-time blood inventory", signed: true)
                        agreementItem("Respond to matches within 24h", signed: true)
                        agreementItem("Comply with R.A. 7719", signed: true)
                        agreementItem("Protect data per R.A. 10173", signed: true)
                    }
                    .padding(.top, 4)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.bloodRed)
                        Text("Partnership agreement not signed")
                            .font(BFont.caption(12))
                            .foregroundColor(.bloodRed)
                    }
                }
            }
        }
        .padding(BSpacing.lg)
        .glassCard()
    }

    private func agreementItem(_ text: String, signed: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: signed ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundColor(signed ? .successGreen.opacity(0.6) : .textSecondary)
            Text(text)
                .font(BFont.caption(12))
                .foregroundColor(.textSecondary)
        }
    }

    // MARK: - Action Buttons
    private var isCompliant: Bool {
        !hospital.licenseNumber.isEmpty
        && hospital.partnershipSignedDate != nil
        && !hospital.contactNumber.isEmpty
        && !hospital.address.isEmpty
    }

    private var actionButtons: some View {
        VStack(spacing: BSpacing.md) {
            // Summary assessment
            VStack(alignment: .leading, spacing: BSpacing.sm) {
                Text("ADMIN ASSESSMENT")
                    .font(BFont.captionBold(12))
                    .foregroundColor(.textSecondary)
                    .tracking(0.5)

                HStack(spacing: BSpacing.md) {
                    assessmentBadge(
                        label: "License",
                        passed: !hospital.licenseNumber.isEmpty
                    )
                    assessmentBadge(
                        label: "Agreement",
                        passed: hospital.partnershipSignedDate != nil
                    )
                    assessmentBadge(
                        label: "Contact",
                        passed: !hospital.contactNumber.isEmpty
                    )
                    assessmentBadge(
                        label: "Address",
                        passed: !hospital.address.isEmpty
                    )
                }
            }
            .padding(BSpacing.lg)
            .glassCard()

            // Warning if not compliant
            if !isCompliant {
                HStack(spacing: BSpacing.sm) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.bloodRed)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Incomplete Compliance")
                            .font(BFont.captionBold(13))
                            .foregroundColor(.bloodRed)

                        let missing = missingItems
                        Text("Missing: \(missing.joined(separator: ", "))")
                            .font(BFont.caption(12))
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(BSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .fill(Color.bloodRed.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: BRadius.md)
                                .stroke(Color.bloodRed.opacity(0.2), lineWidth: 1)
                        )
                )
            }

            HStack(spacing: BSpacing.md) {
                Button {
                    store.rejectHospital(hospital.id)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                        Text("Reject")
                            .font(BFont.headline())
                    }
                    .foregroundColor(.bloodRed)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .stroke(Color.bloodRed, lineWidth: 1.5)
                    )
                }

                Button {
                    store.verifyHospital(hospital.id)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text("Verify")
                            .font(BFont.headline())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: BRadius.md)
                            .fill(isCompliant ? Color.successGreen : Color.textSecondary.opacity(0.3))
                    )
                }
                .disabled(!isCompliant)
            }
        }
    }

    private var missingItems: [String] {
        var items: [String] = []
        if hospital.licenseNumber.isEmpty { items.append("DOH License") }
        if hospital.partnershipSignedDate == nil { items.append("Partnership Agreement") }
        if hospital.contactNumber.isEmpty { items.append("Contact Number") }
        if hospital.address.isEmpty { items.append("Address") }
        return items
    }

    private func assessmentBadge(label: String, passed: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(passed ? .successGreen : .bloodRed)
            Text(label)
                .font(BFont.caption(10))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        AdminHospitalDetailView(hospital: MockData.hospitals.last!)
    }
}
