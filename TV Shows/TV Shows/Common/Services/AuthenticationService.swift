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
    
    static func registerUser(email: String, password: String, onSuccess: @escaping (_ response: DataResponse<UserResponse, AFError>) -> Void){
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        APIManager.shared.request(
            type: AuthRoute.regiser,
            responseDecodableType: UserResponse.self,
            parameters: parameters,
            succsessHandler: onSuccess
        )
    }
    
    static func loginUser(email: String, password: String, onSuccess: @escaping (_ response: DataResponse<UserResponse, AFError>) -> Void){
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        APIManager.shared.request(
            type: AuthRoute.login,
            responseDecodableType: UserResponse.self,
            parameters: parameters,
            succsessHandler: onSuccess
        )
    }
    
}
