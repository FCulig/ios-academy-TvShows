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
    
    static func registerUser(email: String, password: String){
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                switch dataResponse.result {
                case .success(_):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    // self?.loginUser(parameters: parameters)
                case .failure(var error):
                    // TODO: Pokazi error s backenda
                    SVProgressHUD.showError(withStatus: "Error processing request")
                }
            }
    }
    
    static func loginUser(email: String, password: String){
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        APIManager.shared.request(
            url: "https://tv-shows.infinum.academy/users/sign_in",
            parameters: parameters,
            method: .post,
            responseDecodableType: UserResponse.self,
            succsessHandler: saveAuthenticationHeaders
        )
    }
    
    private static func saveAuthenticationHeaders(response: DataResponse<UserResponse, AFError>){
        let headers = response.response?.headers.dictionary ?? [:]
        print(headers)
    }
    
    // SVProgressHUD.showError(withStatus: "Failure")
    
}
