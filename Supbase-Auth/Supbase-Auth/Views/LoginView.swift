//
//  LoginView.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.black)
                        .accessibilityHidden(true)
                    
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
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
                    
                    Button(action: {
                        showForgotPassword = true
                    }) {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel("Forgot Password")
                }
                
                // Sign In Button
                PrimaryButton(
                    title: "Sign In",
                    isLoading: authViewModel.isLoading
                ) {
                    authViewModel.clearError()
                    Task {
                        await authViewModel.signIn(email: email, password: password)
                    }
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
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    NavigationLink("Sign Up") {
                        RegisterView()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
                .font(.subheadline)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
