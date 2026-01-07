//
//  AuthService.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import Foundation
import Supabase

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case userNotFound
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .userNotFound:
            return "No account found with this email"
        case .networkError:
            return "Network connection error. Please try again"
        case .unknown(let message):
            return message
        }
    }
}

@MainActor
class AuthService {
    private let client = SupabaseConfig.client
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> User {
        do {
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )

            let user = response.user

            return User(
                id: user.id,
                email: user.email ?? email,
                createdAt: user.createdAt
            )
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        do {
            let response = try await client.auth.signIn(
                email: email,
                password: password
            )
            
            return User(
                id: response.user.id,
                email: response.user.email ?? email,
                createdAt: response.user.createdAt
            )
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        do {
            try await client.auth.resetPasswordForEmail(email)
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Sign Out
    func signOut() async throws {
        do {
            try await client.auth.signOut()
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Get Current Session
    func getCurrentSession() async throws -> User? {
        do {
            let session = try await client.auth.session
            return User(
                id: session.user.id,
                email: session.user.email ?? "",
                createdAt: session.user.createdAt
            )
        } catch {
            return nil
        }
    }
    
    // MARK: - Error Mapping
    private func mapError(_ error: Error) -> AuthError {
        let errorMessage = error.localizedDescription.lowercased()
        
        if errorMessage.contains("email") || errorMessage.contains("invalid") {
            return .invalidEmail
        } else if errorMessage.contains("password") {
            return .weakPassword
        } else if errorMessage.contains("not found") || errorMessage.contains("user") {
            return .userNotFound
        } else if errorMessage.contains("network") || errorMessage.contains("connection") {
            return .networkError
        } else {
            return .unknown(error.localizedDescription)
        }
    }
}
