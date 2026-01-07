//
//  ForgotPasswordView.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "lock.rotation")
                            .font(.system(size: 80))
                            .foregroundColor(.black)
                            .accessibilityHidden(true)
                        
                        Text("Reset Password")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Enter your email to receive a password reset link")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Success Message
                    if showSuccessMessage {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Password reset link sent! Check your email.")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityElement(children: .combine)
                    }
                    
                    // Error Message
                    if let errorMessage = authViewModel.errorMessage {
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
                    
                    // Form Field
                    CustomTextField(
                        icon: "envelope.fill",
                        placeholder: "Email",
                        text: $email
                    )
                    
                    // Reset Password Button
                    PrimaryButton(
                        title: "Send Reset Link",
                        isLoading: authViewModel.isLoading
                    ) {
                        handleResetPassword()
                    }
                    .padding(.top, 8)
                    
                    // Cancel Button
                    SecondaryButton(title: "Cancel") {
                        dismiss()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
    }
    
    private func handleResetPassword() {
        authViewModel.clearError()
        showSuccessMessage = false
        
        Task {
            let success = await authViewModel.resetPassword(email: email)
            if success {
                showSuccessMessage = true
                
                // Auto-dismiss after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel())
}
