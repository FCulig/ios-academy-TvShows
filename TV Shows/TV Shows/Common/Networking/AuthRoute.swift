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
    
    case regiser
    case login
    
}

// MARK: - Extension

extension AuthRoute: EndPointType {
    
    var path: String {
        switch self {
        case .login:
            return "/users/sign_in"
        case .regiser:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
}
