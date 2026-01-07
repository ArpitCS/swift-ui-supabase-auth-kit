//
//  User.swift
//  Supbase-Auth
//
//  Created on 1/5/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}
