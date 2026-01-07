//
//  CustomTextField.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import SwiftUI

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @State private var isSecureVisible = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
                .accessibilityHidden(true)
            
            if isSecure && !isSecureVisible {
                SecureField(placeholder, text: $text)
                    .focused($isFocused)
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .accessibilityLabel(placeholder)
            } else {
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .textContentType(isSecure ? .password : .emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(isSecure ? .default : .emailAddress)
                    .accessibilityLabel(placeholder)
            }
            
            if isSecure {
                Button(action: {
                    isSecureVisible.toggle()
                }) {
                    Image(systemName: isSecureVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
                .accessibilityLabel(isSecureVisible ? "Hide password" : "Show password")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.black : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isLoading)
        .accessibilityLabel(isLoading ? "Loading" : title)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1.5)
                )
        }
        .accessibilityLabel(title)
    }
}
