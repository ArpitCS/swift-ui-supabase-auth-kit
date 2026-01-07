//
//  Supbase_AuthApp.swift
//  Supbase-Auth
//
//  Created by Arpit Garg on 05/01/26.
//

import SwiftUI

@main
struct Supbase_AuthApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
