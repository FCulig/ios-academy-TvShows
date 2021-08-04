//
//  ReviewsRoute.swift
//  TV Shows
//
//  Created by Infinum Infinum on 27.07.2021..
//

import Foundation
import Alamofire

enum ReviewsRoute {
    
    // MARK: - Reviews routes
    
    case getReviews(showId: String,page: Int?, items: Int?)
    case postReview(rating: Int, comment: String, showId: String)
    
}

// MARK: - Extension

extension ReviewsRoute: EndPointType {
    
    var path: String {
        switch self {
        case .getReviews(let showId, _, _):
            return "/shows/" + showId + "/reviews"
        case .postReview:
            return "/reviews"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getReviews:
            return .get
        case .postReview:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getReviews(_, let page, let items):
            return [
                "page": page ?? 1,
                "items": items ?? 20
            ]
        case .postReview(let rating, let comment, let showId):
            return [
                "rating": rating,
                "comment": comment,
                "show_id": showId
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
