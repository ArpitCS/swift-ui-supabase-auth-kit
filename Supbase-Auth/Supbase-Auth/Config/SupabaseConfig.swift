//
//  SupabaseConfig.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import Foundation
import Supabase

enum SupabaseConfig {
    // MARK: - Configuration
    // Replace these with your actual Supabase project credentials
    static let supabaseURL = "supavaseurl"
    static let supabaseAnonKey = "supabasekey"
    
    // MARK: - Shared Client
    static let client: SupabaseClient = {
        guard let url = URL(string: supabaseURL) else {
            fatalError("Invalid Supabase URL")
        }
        
        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseAnonKey
        )
    }()
}
