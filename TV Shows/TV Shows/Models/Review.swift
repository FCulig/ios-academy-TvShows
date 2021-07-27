//
//  Review.swift
//  TV Shows
//
//  Created by Infinum Infinum on 27.07.2021..
//

import Foundation

struct Review: Codable {
    
    // MARK: - Vars and lets
    
    let id: Int
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    // MARK: - Coding key

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
    
}
