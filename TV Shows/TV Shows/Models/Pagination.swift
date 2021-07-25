//
//  File.swift
//  TV Shows
//
//  Created by Infinum Infinum on 25.07.2021..
//

import Foundation

struct Pagination: Codable {
    
    // MARK: - Vars and lets
    
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
    
}
