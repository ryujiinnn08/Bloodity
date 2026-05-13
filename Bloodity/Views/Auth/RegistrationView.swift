import SwiftUI

struct RegistrationView: View {
    @Bindable var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.deepNavy.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
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
                            // Name
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Full Name")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.textSecondary)
                                    TextField("", text: $authVM.regName, prompt: Text("Juan Dela Cruz").foregroundColor(.textSecondary.opacity(0.5)))
                                        .foregroundColor(.textPrimary)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: BRadius.md)
                                        .fill(Color.cardDark)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: BRadius.md)
                                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                        )
                                )
                            }

                            // Phone
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Phone Number")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                HStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.textSecondary)
                                    TextField("", text: $authVM.regPhone, prompt: Text("+63 9XX XXX XXXX").foregroundColor(.textSecondary.opacity(0.5)))
                                        .foregroundColor(.textPrimary)
                                        .keyboardType(.phonePad)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: BRadius.md)
                                        .fill(Color.cardDark)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: BRadius.md)
                                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                        )
                                )
                            }

                            // Blood Type
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
                                            Text(type.rawValue)
                                                .font(BFont.headline(15))
                                                .foregroundColor(authVM.regBloodType == type ? .white : .textSecondary)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 44)
                                                .background(
                                                    RoundedRectangle(cornerRadius: BRadius.sm)
                                                        .fill(authVM.regBloodType == type ? type.color.gradient : Color.cardDark.gradient)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: BRadius.sm)
                                                        .stroke(
                                                            authVM.regBloodType == type ? Color.clear : Color.white.opacity(0.08),
                                                            lineWidth: 1
                                                        )
                                                )
                                        }
                                    }
                                }
                            }

                            // Role
                            VStack(alignment: .leading, spacing: 6) {
                                Text("I am a")
                                    .font(BFont.captionBold())
                                    .foregroundColor(.textSecondary)

                                HStack(spacing: 8) {
                                    ForEach(UserRole.allCases, id: \.rawValue) { role in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) {
                                                authVM.regRole = role
                                            }
                                        } label: {
                                            VStack(spacing: 6) {
                                                Image(systemName: role.icon)
                                                    .font(.system(size: 20))
                                                Text(role.rawValue)
                                                    .font(BFont.captionBold())
                                            }
                                            .foregroundColor(authVM.regRole == role ? .white : .textSecondary)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 70)
                                            .background(
                                                RoundedRectangle(cornerRadius: BRadius.md)
                                                    .fill(authVM.regRole == role ? role.color.gradient : Color.cardDark.gradient)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: BRadius.md)
                                                    .stroke(
                                                        authVM.regRole == role ? Color.clear : Color.white.opacity(0.08),
                                                        lineWidth: 1
                                                    )
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Register Button
                        Button {
                            authVM.register()
                        } label: {
                            HStack {
                                if authVM.isVerifying {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "person.badge.plus")
                                    Text("Create Account")
                                }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(authVM.regName.isEmpty || authVM.regPhone.isEmpty)
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
}

#Preview {
    RegistrationView(authVM: AuthViewModel())
}
