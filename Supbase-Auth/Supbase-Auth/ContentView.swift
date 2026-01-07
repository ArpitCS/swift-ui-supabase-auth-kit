//
//  ContentView.swift
//  Supbase-Auth
//
//  Created by Arpit Garg on 05/01/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoading {
                // Loading State
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .foregroundColor(.gray)
                }
            } else if authViewModel.isAuthenticated {
                // Authenticated State - Main App Content
                HomeView()
            } else {
                // Not Authenticated - Show Auth Flow
                AuthenticationView()
            }
        }
    }
}

// MARK: - Home View (Placeholder for authenticated content)
struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let user = authViewModel.currentUser {
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                PrimaryButton(
                    title: "Sign Out",
                    isLoading: authViewModel.isLoading
                ) {
                    Task {
                        await authViewModel.signOut()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .padding(.top, 60)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
