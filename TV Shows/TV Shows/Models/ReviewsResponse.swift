//
//  ReviewsResponse.swift
//  TV Shows
//
//  Created by Infinum Infinum on 27.07.2021..
//

import Foundation

struct ReviewsResponse: Codable {
    
    // MARK: - Vars and lets
    
    let reviews: [Review]
    let meta: ResponseMetadata
    
}
