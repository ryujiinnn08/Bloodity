import SwiftUI

struct RegistrationView: View {
    @Bindable var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

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
                                label: "Phone Number",
                                icon: "phone.fill",
                                placeholder: "+63 9XX XXX XXXX",
                                text: $authVM.regPhone,
                                keyboard: .phonePad
                            )

                            // 5. Address (essential for hospitals, optional for users)
                            if isHospital {
                                formField(
                                    label: "Address / Location",
                                    icon: "mappin.and.ellipse",
                                    placeholder: "Taft Ave, Ermita, Manila",
                                    text: $authVM.regAddress
                                )
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
                                    Text(isHospital ? "Register Hospital" : "Create Account")
                                }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)
                        .padding(.horizontal)

                        // Data privacy notice
                        Text("By registering, you agree to Bloodity's Terms of Service and Privacy Policy in compliance with R.A. 10173 (Data Privacy Act of 2012).")
                            .font(BFont.caption(11))
                            .foregroundColor(.textSecondary.opacity(0.6))
                            .multilineTextAlignment(.center)
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
        }
    }

    // MARK: - Form Validation

    private var isFormValid: Bool {
        if isHospital {
            return !authVM.regName.isEmpty && !authVM.regPhone.isEmpty && !authVM.regAddress.isEmpty
        } else {
            return !authVM.regName.isEmpty && !authVM.regPhone.isEmpty
        }
    }

    // MARK: - Role Selector (Top of form)
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

    // MARK: - Blood Type Selector (Users only)
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
                Text("Hospital Verification")
                    .font(BFont.captionBold())
                    .foregroundColor(.textPrimary)
                Text("Hospital accounts require admin verification before full access is granted. You can explore the dashboard immediately.")
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
