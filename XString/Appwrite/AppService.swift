//
//  Appservice.swift
//  XString
//
//  Created by AeroStar on 14/12/2025.
//


import Appwrite
import Foundation
internal import Combine
import JSONCodable
import AppwriteModels

enum RequestStatus {
    case success
    case error(_ message: String)
}

enum AccountResult {
    case success(_ user: User<[String: AnyCodable]>)
    case error(_ message: String)
}

enum VerificationResult {
    case success(_ token: Token)
    case error(_ message: String)
}

final class AppService {

    static let shared = AppService()

    let client: Client
    let account: Account

    private init() {
        client = Client()
            .setEndpoint("https://sfo.cloud.appwrite.io/v1")
            .setProject("6929fa17002f152bea76")

        account = Account(client)
    }


    func createUser(name: String, email: String, password: String) async throws -> RequestStatus {
        do {
            _ = try await account.create(userId: ID.unique(), email: email, password: password, name: name)
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func login(email: String, password: String) async throws -> RequestStatus {
        do {
            _ = try await account.createEmailPasswordSession(email: email, password: password)
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func logout() async throws -> RequestStatus {
        do {
            _ = try await account.deleteSession(sessionId: "current")
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func getCurrentUser() async throws -> AccountResult {
        do {
            let user = try await account.get()
            return .success(user)
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func createEmailVerification(redirectURL: String) async throws -> VerificationResult {
        do {
            print("📤 Calling Appwrite API with URL: \(redirectURL)")
            let token = try await account.createVerification(url: redirectURL)
            print("✅ Appwrite API response successful")
            return .success(token)
        } catch {
            print("❌ Appwrite API error: \(error.localizedDescription)")
            return .error(error.localizedDescription)
        }
    }
    
    func confirmEmailVerification(userId: String, secret: String) async throws -> VerificationResult {
        do {
            let token = try await account.updateVerification(userId: userId, secret: secret)
            return .success(token)
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    
    func createPhoneVerification() async throws -> VerificationResult {
        do {
            let token = try await account.createPhoneVerification()
            return .success(token)
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func confirmPhoneVerification(userId: String, secret: String) async throws -> VerificationResult {
        do {
            let token = try await account.updatePhoneVerification(userId: userId, secret: secret)
            return .success(token)
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func updatePhone(phoneNumber: String, password: String) async throws -> RequestStatus {
        do {
            _ = try await account.updatePhone(phone: phoneNumber, password: password)
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func createPasswordRecovery(email: String, url: String) async throws -> VerificationResult {
        do {
            let token = try await account.createRecovery(email: email, url: url)
            return .success(token)
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func confirmPasswordRecovery(userId: String, secret: String, password: String) async throws -> VerificationResult {
        do {
            let token = try await account.updateRecovery(userId: userId, secret: secret, password: password)
            return .success(token)
        } catch {
            return .error(error.localizedDescription)
        }
    }
}
