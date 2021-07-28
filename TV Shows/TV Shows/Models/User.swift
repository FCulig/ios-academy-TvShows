//
//  User.swift
//  TV Shows
//
//  Created by Infinum Infinum on 19.07.2021..
//

import Foundation

struct User: Codable {
    
    // MARK: - Vars & Lets
    
    let email: String
    let imageUrl: String?
    let id: String
    
    // MARK: - Coding key

    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}
