//
//  ReviewsRoute.swift
//  TV Shows
//
//  Created by Infinum Infinum on 27.07.2021..
//

import Foundation
import Alamofire

enum ReviewsRoute {
    
    // MARK: - Authentication routes
    
    case getReviews(showId: Int,page: Int?, items: Int?)
    
}

// MARK: - Extension

extension ReviewsRoute: EndPointType {
    
    var path: String {
        switch self {
        case .getReviews(let showId, _, _):
            return "/shows/" + String(showId) + "/reviews"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .getReviews(_, let page, let items):
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
