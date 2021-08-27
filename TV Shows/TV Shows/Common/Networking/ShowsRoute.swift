//
//  ShowsRoute.swift
//  TV Shows
//
//  Created by Infinum Infinum on 25.07.2021..
//

import Foundation
import Alamofire

enum ShowsRoute {
    
    // MARK: - Authentication routes
    
    case getShows(page: Int?, items: Int?)
    
}

// MARK: - Extension

extension ShowsRoute: EndPointType {
    
    var path: String {
        switch self {
        case .getShows:
            return "/shows"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .getShows(let page, let items):
            return [
                "page": page ?? 1,
                "items": items ?? 20
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest.init(url: self.url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        request.headers = self.headers
        return try URLEncoding.default.encode(request,with: parameters)
    }
    
}

