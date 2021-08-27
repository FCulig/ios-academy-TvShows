//
//  ShowsResponse.swift
//  TV Shows
//
//  Created by Infinum Infinum on 25.07.2021..
//

import Foundation

struct ShowsResponse: Codable {
    
    // MARK: - Vars and lets
    
    let shows: [Show]
    let meta: ResponseMetadata
    
}
