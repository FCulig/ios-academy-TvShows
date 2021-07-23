//
//  EndPointType.swift
//  TV Shows
//
//  Created by Infinum Infinum on 21.07.2021..
//

import Alamofire

protocol EndPointType : URLRequestConvertible{
    
    // MARK: - Vars & Lets
        
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var url: URL { get }
    var parameters: Parameters? { get }
    
}

// MARK: - Extension

extension EndPointType {
    
    var baseURL: String {
        get {
            "https://tv-shows.infinum.academy/"
        }
    }
    
    var url: URL {
        get {
            URL(string: self.baseURL + self.path)!
        }
    }
    
}
