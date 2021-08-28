//
//  UserRoute.swift
//  TV Shows
//
//  Created by Infinum Infinum on 04.08.2021..
//

import Foundation
import Alamofire

enum UserRoute {
    
    // MARK: - User routes
    
    case getCurrentUser
    case updateProfileImage
    
}

// MARK: - Extension

extension UserRoute: EndPointType {
    
    var path: String {
        switch self {
        case .getCurrentUser:
            return "/users/me"
        case .updateProfileImage:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentUser:
            return .get
        case .updateProfileImage:
            return .put
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getCurrentUser:
            return [:]
        case .updateProfileImage:
            return [:]
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
