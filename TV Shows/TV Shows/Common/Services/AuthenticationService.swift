//
//  AuthenticationService.swift
//  TV Shows
//
//  Created by Infinum Infinum on 21.07.2021..
//

import Foundation
import SVProgressHUD
import Alamofire

final class AuthenticationService {
    
    static func registerUser(email: String, password: String, onSuccess: @escaping (_ response: DataResponse<UserResponse, AFError>) -> Void) {
        APIManager.shared.request(
            endpoint: AuthRoute.register(email: email, password: password),
            responseDecodableType: UserResponse.self,
            succsessHandler: onSuccess
        )
    }
    
    static func loginUser(email: String, password: String, onSuccess: @escaping (_ response: DataResponse<UserResponse, AFError>) -> Void) {
        APIManager.shared.request(
            endpoint: AuthRoute.login(email: email, password: password),
            responseDecodableType: UserResponse.self,
            succsessHandler: onSuccess
        )
    }
    
}
