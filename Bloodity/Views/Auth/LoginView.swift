import SwiftUI

struct LoginView: View {
    @Bindable var authVM: AuthViewModel

    @State private var appearAnimation = false

    var body: some View {
        ZStack {
            Color.deepNavy.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: BSpacing.xxl) {
                    // Header
                    VStack(spacing: BSpacing.md) {
                        Image("BLOODITY-LOGO")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 40)

                        Image("BLOODITY")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)

                        Text("Sign in to save lives")
                            .font(BFont.body())
                            .foregroundColor(.textSecondary)
                    }
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : -20)

                    // Demo Accounts Section
                    VStack(alignment: .leading, spacing: BSpacing.md) {
                        Text("Quick Access")
                            .font(BFont.headline())
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, BSpacing.xs)

                        ForEach(Array(authVM.demoAccounts.enumerated()), id: \.1.phone) { index, account in
                            Button {
                                authVM.loginWithDemoAccount(account.user)
                            } label: {
                                HStack(spacing: BSpacing.md) {
                                    ZStack {
                                        Circle()
                                            .fill(account.user.role.color.gradient)
                                            .frame(width: 44, height: 44)
                                        Image(systemName: account.user.role.icon)
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(account.user.name)
                                            .font(BFont.headline(15))
                                            .foregroundColor(.textPrimary)

                                        HStack(spacing: 6) {
                                            Text(account.user.role.rawValue)
                                                .font(BFont.caption())
                                                .foregroundColor(account.user.role.color)

                                            Text("•")
                                                .foregroundColor(.textSecondary)

                                            BloodTypeBadge(bloodType: account.user.bloodType, size: .small)
                                        }
                                    }

                                    Spacer()

                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(account.user.role.color)
                                }
                                .padding(BSpacing.lg)
                                .glassCard()
                            }
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                            .animation(.spring(response: 0.6).delay(Double(index) * 0.1 + 0.3), value: appearAnimation)
                        }

                        // Demo Admin — distinct gold/amber card
                        Button {
                            authVM.loginWithDemoAccount(AuthViewModel.adminAccount)
                        } label: {
                            HStack(spacing: BSpacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.warmAmber, Color(red: 0.85, green: 0.55, blue: 0.05)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "shield.checkered")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Demo Admin")
                                        .font(BFont.headline(15))
                                        .foregroundColor(.textPrimary)

                                    Text("Full System Access • Dashboard & AI")
                                        .font(BFont.caption())
                                        .foregroundColor(.warmAmber)
                                }

                                Spacer()

                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.warmAmber)
                            }
                            .padding(BSpacing.lg)
                            .background(
                                RoundedRectangle(cornerRadius: BRadius.lg)
                                    .fill(Color.white)
                                    .shadow(color: .warmAmber.opacity(0.15), radius: 8, x: 0, y: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: BRadius.lg)
                                    .stroke(Color.warmAmber.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 20)
                        .animation(.spring(response: 0.6).delay(0.5), value: appearAnimation)
                    }
                    .padding(.horizontal)

                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                        Text("or sign in with phone")
                            .font(BFont.caption())
                            .foregroundColor(.textSecondary)
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                    .opacity(appearAnimation ? 1 : 0)

                    // Phone Login
                    VStack(spacing: BSpacing.lg) {
                        // Phone Field
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.textSecondary)
                            TextField("", text: $authVM.phoneNumber, prompt: Text("+63 9XX XXX XXXX").foregroundColor(.textSecondary.opacity(0.5)))
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

                        if authVM.isOTPSent {
                            // OTP Field
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.textSecondary)
                                TextField("", text: $authVM.otpCode, prompt: Text("Enter 6-digit OTP").foregroundColor(.textSecondary.opacity(0.5)))
                                    .foregroundColor(.textPrimary)
                                    .keyboardType(.numberPad)
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
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // Submit Button
                        Button {
                            if authVM.isOTPSent {
                                authVM.verifyOTP()
                            } else {
                                authVM.sendOTP()
                            }
                        } label: {
                            HStack {
                                if authVM.isVerifying {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text(authVM.isOTPSent ? "Verify OTP" : "Send OTP")
                                }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(authVM.phoneNumber.count < 5)

                        // Register link
                        Button {
                            withAnimation(.spring(response: 0.4)) {
                                authVM.isRegistering = true
                            }
                        } label: {
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(.textSecondary)
                                Text("Register")
                                    .foregroundColor(.coralPink)
                                    .fontWeight(.semibold)
                            }
                            .font(BFont.body(14))
                        }
                    }
                    .padding(.horizontal)
                    .opacity(appearAnimation ? 1 : 0)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8)) {
                appearAnimation = true
            }
        }
        .sheet(isPresented: $authVM.isRegistering) {
            RegistrationView(authVM: authVM)
        }
    }
}

#Preview {
    LoginView(authVM: AuthViewModel())
}
