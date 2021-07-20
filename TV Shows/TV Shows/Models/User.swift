//
//  User.swift
//  TV Shows
//
//  Created by Infinum Infinum on 19.07.2021..
//

import Foundation

struct User: Codable {
    let email: String
    let imageUrl: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}