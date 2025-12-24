//
//  ViewModel.swift
//  XString
//
//  Created by AeroStar on 15/12/2025.
//



import SwiftUI
import Foundation
internal import Combine
import AppwriteModels
import JSONCodable
internal import AppwriteEnums

class UserAuthModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var nameText: String = ""
}

@MainActor
class ViewModel: ObservableObject {
    private let service = AppService.shared

    
    // Base vars
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var hasError = false
    @Published var isLoading = false
    @Published var isLoggedIn = false
    @Published var currentUser: User<[String: AnyCodable]>? = nil
    // Verification vars
    @Published var emailVerificationSent = false
    @Published var phoneVerificationSent = false
    @Published var showEmailVerificationPrompt = false
    @Published var showPhoneVerificationPrompt = false
    @Published var showPasswordRecoveryPrompt = false
    @Published var pendingVerificationUserId: String? = nil
    @Published var isEmailVerified: Bool = false
    @Published var isPhoneVerified: Bool = false
    @Published var showVerificationView: Bool = false
    private let userAuth: UserAuthModel

    init(userAuth: UserAuthModel) {
        self.userAuth = userAuth
    }


    func createUser(name: String, email: String, password: String) async throws {
        isLoading = true
        let status = try await service.createUser(name: name, email: email, password: password)
        
        switch status {
            
        case .success:
            hasError = false
            isLoading = false
            alertMessage = "Your Aero ID Has Been Registered"
            showAlert.toggle()

        case .error(let message):
            isLoading = false
            hasError = true
            alertMessage = message
            showAlert.toggle()
        }
    }

    func login(email: String, password: String) async throws {
        isLoading = true
        let _ = try await service.logout()
        let status = try await service.login(email: email, password: password)
        
        switch status {
            
        case .success:
            hasError = false
            isLoading = false
            alertMessage = "Succcessfully signed in"
            isLoggedIn = true
        case .error(let message):
            isLoading = false
            hasError = true
            alertMessage = message
            showAlert.toggle()
        }
    }
    // logout
    func logout() async throws {
        isLoading = true
        let status = try await service.logout()
        
        switch status {
            
        case .success:
            hasError = false
            isLoading = false
            isLoggedIn = false
            currentUser = nil
        case .error(let message):
            isLoading = false
            hasError = true
            alertMessage = message
            showAlert.toggle()
        }
    }
    // get current user - gets current user from appwrite servers
    func getCurrentUser() async throws {
        isLoading = true
        let result = try await service.getCurrentUser()
        
        switch result {
            
        case .success(let user):
            hasError = false
            isLoading = false
            currentUser = user
            isLoggedIn = true
            
            updateVerificationStatus(from: user)
            
        case .error(let message):
            isLoading = false
            hasError = false
            alertMessage = message
            showAlert.toggle()
            isLoggedIn = false
            currentUser = nil
        }
    }
    func checkAuthStatus() async throws {
        try await getCurrentUser()
    }
    func sendEmailVerification(redirectURL: String = "https://verification-lac.vercel.app") async throws {
        isLoading = true
        let result = try await service.createEmailVerification(redirectURL: redirectURL)
        
        switch result {
        case .success(let token):
            print("✅ Email verification API call successful")
            print("📧 Token userId: \(token.userId)")
            isLoading = false
            hasError = false
            emailVerificationSent = true
            pendingVerificationUserId = token.userId
            alertMessage = "Verification email sent! Please check your inbox."
            showAlert = true
            
        case .error(let message):
            print("❌ Email verification failed: \(message)")
            isLoading = false
            hasError = true
            alertMessage = "Failed to send verification email: \(message)"
            showAlert = true
        }
    }
    
    
    func updatePhoneNumber(phoneNumber: String, password: String) async throws {
        isLoading = true
        let result = try await service.updatePhone(phoneNumber: phoneNumber, password: password)
        
        switch result {
        case .success:
            isLoading = false
            hasError = false
            alertMessage = "Phone number updated successfully!"
            showAlert = true
            
            try await getCurrentUser()
            
        case .error(let message):
            isLoading = false
            hasError = true
            alertMessage = "Failed to update phone number: \(message)"
            showAlert = true
        }
    }
    func sendPasswordReset(email: String, resetURL: String = "https://verification-lac.vercel.app/reset.html") async throws {
         isLoading = true
         let result = try await service.createPasswordRecovery(email: email, url: resetURL)
         
         switch result {
         case .success(_):
             isLoading = false
             hasError = false
             alertMessage = "Password reset email sent! Please check your inbox."
             showAlert = true
             
         case .error(let message):
             isLoading = false
             hasError = true
             alertMessage = "Failed to send password reset email: \(message)"
             showAlert = true
         }
     }
    private func updateVerificationStatus(from user: User<[String: AnyCodable]>) {
        isEmailVerified = user.emailVerification
        
        isPhoneVerified = user.phoneVerification
        
        if !isEmailVerified && !showEmailVerificationPrompt {
            showEmailVerificationPrompt = true
        }
        
        if !isPhoneVerified && user.phone.isEmpty == false && !showPhoneVerificationPrompt {
            showPhoneVerificationPrompt = true
        }
    }
    
    private func resetVerificationStates() {
        emailVerificationSent = false
        phoneVerificationSent = false
        showEmailVerificationPrompt = false
        showPhoneVerificationPrompt = false
        showPasswordRecoveryPrompt = false
        pendingVerificationUserId = nil
        isEmailVerified = false
        isPhoneVerified = false
    }
    
    var needsVerification: Bool {
        guard let user = currentUser else { return false }
        return !user.emailVerification || (!user.phone.isEmpty && !user.phoneVerification)
    }
    
    func resendVerification(type: VerificationType) async throws {
        switch type {
        case .email:
            try await sendEmailVerification()
        }
    }
}

enum VerificationType {
    case email
}
