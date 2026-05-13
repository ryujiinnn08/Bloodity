import SwiftUI

@Observable
class AuthViewModel {
    var isAuthenticated = false
    var isShowingSplash = true
    var currentUser: User?
    var isRegistering = false

    // Login fields
    var phoneNumber = ""
    var otpCode = ""
    var isOTPSent = false
    var isVerifying = false

    // Registration fields
    var regName = ""
    var regPhone = ""
    var regBloodType: BloodType = .oPositive
    var regRole: UserRole = .user

    // Demo accounts
    let demoAccounts: [(label: String, phone: String, user: User)] = [
        ("User — Juan Dela Cruz", "+63 917 123 4567", MockData.userAccount),
        ("Hospital — Dr. Elena Reyes", "+63 919 555 0123", MockData.hospitalAccount),
    ]

    func sendOTP() {
        isVerifying = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            self.isOTPSent = true
            self.isVerifying = false
        }
    }

    func verifyOTP() {
        isVerifying = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            // Check demo accounts
            if let account = self.demoAccounts.first(where: { $0.phone == self.phoneNumber }) {
                self.currentUser = account.user
                self.isAuthenticated = true
            } else {
                // Any OTP works for demo
                self.currentUser = MockData.userAccount
                self.isAuthenticated = true
            }
            self.isVerifying = false
        }
    }

    func loginWithDemoAccount(_ user: User) {
        currentUser = user
        withAnimation(.spring(response: 0.5)) {
            isAuthenticated = true
        }
    }

    func register() {
        isVerifying = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            let newUser = User(
                id: UUID(),
                name: self.regName,
                phone: self.regPhone,
                bloodType: self.regBloodType,
                role: self.regRole,
                latitude: 14.5995,
                longitude: 120.9842,
                isAvailable: true,
                lastDonationDate: nil,
                registrationDate: Date(),
                totalDonations: 0,
                profileImageName: nil
            )
            self.currentUser = newUser
            self.isAuthenticated = true
            self.isVerifying = false
        }
    }

    func logout() {
        withAnimation(.spring(response: 0.5)) {
            isAuthenticated = false
            currentUser = nil
            phoneNumber = ""
            otpCode = ""
            isOTPSent = false
            isRegistering = false
        }
    }

    func completeSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            withAnimation(.easeInOut(duration: 0.6)) {
                self?.isShowingSplash = false
            }
        }
    }
}
