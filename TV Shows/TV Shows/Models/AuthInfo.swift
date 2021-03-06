//
//  AuthInfo.swift
//  TV Shows
//
//  Created by Infinum Infinum on 20.07.2021..
//

import Foundation

struct AuthInfo: Codable {
    
    // MARK: - Vars & Lets

    let accessToken: String
    let client: String
    let tokenType: String
    let expiry: String
    let uid: String
    
    // MARK: - CodingKey

    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case client = "client"
        case tokenType = "token-type"
        case expiry = "expiry"
        case uid = "uid"
    }
    
    // MARK: - Initializer
    
    init(headers: [String: String]) throws {
        let data = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    var headers: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return jsonObject as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }

}
