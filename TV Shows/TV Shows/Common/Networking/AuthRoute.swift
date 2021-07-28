//
//  AuthRoute.swift
//  TV Shows
//
//  Created by Infinum Infinum on 21.07.2021..
//

import Foundation
import Alamofire

enum AuthRoute {
    
    // MARK: - Authentication routes
    
    case register(email: String, password: String)
    case login(email: String, password: String)
    
}

// MARK: - Extension

extension AuthRoute: EndPointType {
    
    var path: String {
        switch self {
        case .login:
            return "/users/sign_in"
        case .register:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .register(let email, let password):
            return [
                "email": email,
                "password": password,
                "password_confirmation": password
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest.init(url: self.url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request,with: parameters)
    }
    
}
