//
//  RegisterView.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var localError: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.badge.plus.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.black)
                        .accessibilityHidden(true)
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Sign up to get started")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                // Error Message
                if let errorMessage = localError ?? authViewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityElement(children: .combine)
                }
                
                // Form Fields
                VStack(spacing: 16) {
                    CustomTextField(
                        icon: "envelope.fill",
                        placeholder: "Email",
                        text: $email
                    )
                    
                    CustomTextField(
                        icon: "lock.fill",
                        placeholder: "Password",
                        text: $password,
                        isSecure: true
                    )
                    
                    CustomTextField(
                        icon: "lock.fill",
                        placeholder: "Confirm Password",
                        text: $confirmPassword,
                        isSecure: true
                    )
                }
                
                // Password Requirements
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(password.count >= 6 ? .green : .gray)
                        Text("At least 6 characters")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Image(systemName: !confirmPassword.isEmpty && password == confirmPassword ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(!confirmPassword.isEmpty && password == confirmPassword ? .green : .gray)
                        Text("Passwords match")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Password requirements")
                
                // Sign Up Button
                PrimaryButton(
                    title: "Sign Up",
                    isLoading: authViewModel.isLoading
                ) {
                    handleSignUp()
                }
                .padding(.top, 8)
                
                // Divider
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("OR")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.vertical, 8)
                .accessibilityHidden(true)
                
                // Sign In Link
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button("Sign In") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
                .font(.subheadline)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func handleSignUp() {
        localError = nil
        authViewModel.clearError()
        
        // Validate passwords match
        guard password == confirmPassword else {
            localError = "Passwords do not match"
            return
        }
        
        // Validate password length
        guard password.count >= 6 else {
            localError = "Password must be at least 6 characters"
            return
        }
        
        Task {
            await authViewModel.signUp(email: email, password: password)
            if authViewModel.isAuthenticated {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
