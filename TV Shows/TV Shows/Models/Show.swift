//
//  Show.swift
//  TV Shows
//
//  Created by Infinum Infinum on 25.07.2021..
//

import Foundation

struct Show: Codable {
    
    // MARK: - Vars & Lets
    
    let id: String
    let title: String
    let description: String?
    let imageUrl: String?
    let numberOfReviews: Int
    let averageRating: Double
    
    // MARK: - Coding key

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case numberOfReviews = "no_of_reviews"
        case averageRating = "average_rating"
    }
}
