//
//  AuthenticationView.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            LoginView()
        }
        .tint(.black)
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthViewModel())
}
