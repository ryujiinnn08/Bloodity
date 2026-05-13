import SwiftUI

struct RegistrationView: View {
    @Bindable var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPartnershipTerms = false

    private var isHospital: Bool { authVM.regRole == .hospital }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical) {
                    VStack(spacing: BSpacing.xxl) {
                        // Header
                        VStack(spacing: BSpacing.sm) {
                            BloodDropLogo(size: 50)
                            Text("Create Account")
                                .font(BFont.display(28))
                                .foregroundColor(.textPrimary)
                            Text("Join the Bloodity community")
                                .font(BFont.body())
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, BSpacing.xxl)

                        // Form
                        VStack(spacing: BSpacing.lg) {

                            // 1. Role — always first
                            roleSelector

                            // 2. Hospital Verification Note
                            if isHospital {
                                hospitalVerificationNote
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }

                            // 3. Name (dynamic label)
                            formField(
                                label: isHospital ? "Hospital Name" : "Full Name",
                                icon: isHospital ? "building.2.fill" : "person.fill",
                                placeholder: isHospital ? "Philippine General Hospital" : "Juan Dela Cruz",
                                text: $authVM.regName
                            )

                            // 4. Phone
                            formField(
                                label: isHospital ? "Official Contact Number" : "Phone Number",
                                icon: "phone.fill",
                                placeholder: "+63 9XX XXX XXXX",
                                text: $authVM.regPhone,
                                keyboard: .phonePad
                            )

                            // 5. Hospital-only fields
                            if isHospital {
                                // Official Address
                                formField(
                                    label: "Official Address",
                                    icon: "mappin.and.ellipse",
                                    placeholder: "Taft Ave, Ermita, Manila",
                                    text: $authVM.regAddress
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .opacity
                                ))

                                // License / Accreditation Number
                                formField(
                                    label: "DOH License / Accreditation No.",
                                    icon: "doc.text.fill",
                                    placeholder: "e.g. DOH-LIC-2024-XXXX",
                                    text: $authVM.regLicenseNumber
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .opacity
                                ))

                                // Digital Partnership Agreement
                                partnershipAgreementSection
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }

                            // 6. Blood Type (users only)
                            if !isHospital {
                                bloodTypeSelector
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }
                        }
                        .padding(.horizontal)
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: authVM.regRole)

                        // Register Button
                        Button {
                            authVM.register()
                        } label: {
                            HStack {
                                if authVM.isVerifying {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: isHospital ? "building.2.fill" : "person.badge.plus")
                                    Text(isHospital ? "Submit for Verification" : "Create Account")
                                }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)
                        .padding(.horizontal)

                        // Data privacy notice
                        VStack(spacing: 6) {
                            Text("By registering, you agree to Bloodity's Terms of Service and Privacy Policy in compliance with R.A. 10173 (Data Privacy Act of 2012).")
                                .font(BFont.caption(11))
                                .foregroundColor(.textSecondary.opacity(0.6))
                                .multilineTextAlignment(.center)

                            if isHospital {
                                Text("Hospital accounts are subject to DOH accreditation verification and Bloodity admin review before activation.")
                                    .font(BFont.caption(11))
                                    .foregroundColor(.warmAmber.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, BSpacing.xxl)
                    }
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
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
            .sheet(isPresented: $showPartnershipTerms) {
                partnershipTermsSheet
            }
        }
    }

    // MARK: - Form Validation

    private var isFormValid: Bool {
        if isHospital {
            return !authVM.regName.isEmpty
                && !authVM.regPhone.isEmpty
                && !authVM.regAddress.isEmpty
                && !authVM.regLicenseNumber.isEmpty
                && authVM.regPartnershipSigned
        } else {
            return !authVM.regName.isEmpty && !authVM.regPhone.isEmpty
        }
    }

    // MARK: - Role Selector
    private var roleSelector: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("I am a")
                .font(BFont.captionBold())
                .foregroundColor(.textSecondary)

            HStack(spacing: 8) {
                ForEach(UserRole.registrableRoles, id: \.rawValue) { role in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            authVM.regRole = role
                        }
                    } label: {
                        let isSelected = authVM.regRole == role
                        let bgGradient: AnyGradient = isSelected ? role.color.gradient : Color.surfaceDark.gradient
                        VStack(spacing: 6) {
                            Image(systemName: role.icon)
                                .font(.system(size: 20))
                            Text(role.rawValue)
                                .font(BFont.captionBold())
                        }
                        .foregroundColor(isSelected ? .white : .textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: BRadius.md)
                                .fill(bgGradient)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: BRadius.md)
                                .stroke(isSelected ? Color.clear : Color.black.opacity(0.06), lineWidth: 1)
                        )
                    }
                }
            }
        }
    }

    // MARK: - Blood Type Selector
    private var bloodTypeSelector: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Blood Type")
                .font(BFont.captionBold())
                .foregroundColor(.textSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(BloodType.allCases) { type in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            authVM.regBloodType = type
                        }
                    } label: {
                        let isSelected = authVM.regBloodType == type
                        let bgGradient: AnyGradient = isSelected ? type.color.gradient : Color.surfaceDark.gradient
                        Text(type.rawValue)
                            .font(BFont.headline(15))
                            .foregroundColor(isSelected ? .white : .textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: BRadius.sm)
                                    .fill(bgGradient)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: BRadius.sm)
                                    .stroke(isSelected ? Color.clear : Color.black.opacity(0.06), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }

    // MARK: - Hospital Verification Note
    private var hospitalVerificationNote: some View {
        HStack(spacing: BSpacing.md) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 22))
                .foregroundColor(.healBlue)

            VStack(alignment: .leading, spacing: 2) {
                Text("Hospital Verification Required")
                    .font(BFont.captionBold())
                    .foregroundColor(.textPrimary)
                Text("Your account will be reviewed by a Bloodity admin after submission. A valid DOH license or accreditation number is required.")
                    .font(BFont.caption(12))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(BSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: BRadius.md)
                .fill(Color.healBlue.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: BRadius.md)
                        .stroke(Color.healBlue.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Digital Partnership Agreement
    private var partnershipAgreementSection: some View {
        VStack(alignment: .leading, spacing: BSpacing.md) {
            Text("Digital Partnership Agreement")
                .font(BFont.captionBold())
                .foregroundColor(.textSecondary)

            VStack(alignment: .leading, spacing: BSpacing.md) {
                // Agreement summary
                HStack(alignment: .top, spacing: BSpacing.sm) {
                    Image(systemName: "doc.richtext.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.warmAmber)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bloodity Partnership Terms")
                            .font(BFont.headline(14))
                            .foregroundColor(.textPrimary)
                        Text("By signing, your institution agrees to participate in the Bloodity donor matching network, maintain accurate blood stock data, and comply with DOH and WHO blood safety standards.")
                            .font(BFont.caption(12))
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                // Key terms
                VStack(alignment: .leading, spacing: 8) {
                    termItem(icon: "checkmark.circle.fill", text: "Maintain accurate, real-time blood inventory data")
                    termItem(icon: "checkmark.circle.fill", text: "Respond to matched donor requests within 24 hours")
                    termItem(icon: "checkmark.circle.fill", text: "Comply with R.A. 7719 (National Blood Services Act)")
                    termItem(icon: "checkmark.circle.fill", text: "Protect donor data per R.A. 10173 (Data Privacy Act)")
                }

                Divider()
                    .background(Color.black.opacity(0.06))

                // View full terms button
                Button {
                    showPartnershipTerms = true
                } label: {
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 14))
                        Text("View Full Partnership Terms")
                            .font(BFont.captionBold(13))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.healBlue)
                    .padding(.vertical, 4)
                }

                Divider()
                    .background(Color.black.opacity(0.06))

                // Digital signature toggle
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        authVM.regPartnershipSigned.toggle()
                    }
                } label: {
                    HStack(spacing: BSpacing.md) {
                        Image(systemName: authVM.regPartnershipSigned ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22))
                            .foregroundColor(authVM.regPartnershipSigned ? .successGreen : .textSecondary.opacity(0.5))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("I digitally sign this Partnership Agreement")
                                .font(BFont.captionBold(13))
                                .foregroundColor(.textPrimary)
                            Text("On behalf of the institution named above")
                                .font(BFont.caption(11))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }

                if authVM.regPartnershipSigned {
                    HStack(spacing: 6) {
                        Image(systemName: "signature")
                            .font(.system(size: 14))
                            .foregroundColor(.successGreen)
                        Text("Digitally signed on \(Date(), format: .dateTime.month(.wide).day().year())")
                            .font(BFont.caption(11))
                            .foregroundColor(.successGreen)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .padding(BSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: BRadius.lg)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BRadius.lg)
                    .stroke(
                        authVM.regPartnershipSigned ? Color.successGreen.opacity(0.4) : Color.black.opacity(0.06),
                        lineWidth: authVM.regPartnershipSigned ? 1.5 : 1
                    )
            )
        }
    }

    private func termItem(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(.successGreen.opacity(0.7))
                .padding(.top, 1)
            Text(text)
                .font(BFont.caption(12))
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Partnership Terms Sheet
    private var partnershipTermsSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BSpacing.xl) {
                    // Title
                    VStack(alignment: .leading, spacing: BSpacing.sm) {
                        Text("Bloodity")
                            .font(BFont.display(28))
                            .foregroundColor(.bloodRed)
                        Text("Hospital Partnership Agreement")
                            .font(BFont.title(20))
                            .foregroundColor(.textPrimary)
                        Text("Effective upon digital confirmation")
                            .font(BFont.caption())
                            .foregroundColor(.textSecondary)
                    }

                    Divider()

                    termsSection(
                        number: "1",
                        title: "Purpose",
                        body: "This agreement establishes a digital partnership between the registering healthcare institution (\"Partner Hospital\") and Bloodity, an AI-based blood stock forecasting and donor matching platform. The partnership aims to improve blood supply accessibility and emergency response across the Philippines."
                    )

                    termsSection(
                        number: "2",
                        title: "Obligations of the Partner Hospital",
                        body: """
                        a) Maintain accurate and up-to-date blood inventory levels within the Bloodity system.
                        b) Respond to matched donor appointments within 24 hours of notification.
                        c) Ensure all blood collection procedures comply with DOH Administrative Order No. 2005-0002 and WHO blood safety guidelines.
                        d) Designate at least one (1) authorized representative to manage the Bloodity hospital account.
                        e) Report any blood safety incidents or stock discrepancies promptly.
                        """
                    )

                    termsSection(
                        number: "3",
                        title: "Obligations of Bloodity",
                        body: """
                        a) Provide the AI-powered donor matching and blood stock forecasting platform at no cost during the partnership period.
                        b) Maintain platform uptime and provide technical support.
                        c) Protect all institutional and patient data in compliance with R.A. 10173 (Data Privacy Act of 2012).
                        d) Facilitate donor matching based on blood type compatibility, proximity, and eligibility.
                        """
                    )

                    termsSection(
                        number: "4",
                        title: "Data Privacy & Compliance",
                        body: "Both parties shall comply with R.A. 10173 (Data Privacy Act), R.A. 7719 (National Blood Services Act), and all applicable DOH regulations regarding blood banking, collection, and transfusion services. Patient and donor data shall be encrypted and access-controlled at all times."
                    )

                    termsSection(
                        number: "5",
                        title: "Accreditation Verification",
                        body: "The Partner Hospital must hold a valid DOH license or accreditation. Bloodity reserves the right to verify the submitted credentials and may suspend the partnership if the institution fails to provide valid documentation within 30 days of registration."
                    )

                    termsSection(
                        number: "6",
                        title: "Termination",
                        body: "Either party may terminate this partnership with 30 days written notice. Bloodity may immediately suspend a Partner Hospital's access in cases of data breach, regulatory violations, or repeated non-compliance with blood safety standards."
                    )
                }
                .padding()
                .padding(.bottom, 40)
            }
            .background(Color.deepNavy)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showPartnershipTerms = false
                    }
                    .foregroundColor(.bloodRed)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func termsSection(number: String, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: BSpacing.sm) {
            Text("Section \(number): \(title)")
                .font(BFont.headline(15))
                .foregroundColor(.textPrimary)
            Text(body)
                .font(BFont.body(14))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Reusable Form Field
    private func formField(
        label: String,
        icon: String,
        placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(BFont.captionBold())
                .foregroundColor(.textSecondary)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(.textSecondary)
                    .frame(width: 20)
                TextField("", text: text, prompt: Text(placeholder).foregroundColor(.textSecondary.opacity(0.5)))
                    .foregroundColor(.textPrimary)
                    .keyboardType(keyboard)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BRadius.md)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BRadius.md)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
    }
}

#Preview {
    RegistrationView(authVM: AuthViewModel())
}
