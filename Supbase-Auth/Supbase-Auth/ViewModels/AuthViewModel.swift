//
//  AuthViewModel.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService = AuthService()
    
    init() {
        Task {
            await checkAuthStatus()
        }
    }
    
    // MARK: - Check Authentication Status
    func checkAuthStatus() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let user = try await authService.getCurrentSession() {
                currentUser = user
                isAuthenticated = true
            } else {
                currentUser = nil
                isAuthenticated = false
            }
        } catch {
            currentUser = nil
            isAuthenticated = false
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async {
        guard validateEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard validatePassword(password) else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(email: email, password: password)
            currentUser = user
            isAuthenticated = true
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        guard validateEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async -> Bool {
        guard validateEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.resetPassword(email: email)
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: - Sign Out
    func signOut() async {
        isLoading = true
        
        do {
            try await authService.signOut()
            currentUser = nil
            isAuthenticated = false
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Validation
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
