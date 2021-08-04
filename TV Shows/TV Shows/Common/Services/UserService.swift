//
//  UserService.swift
//  TV Shows
//
//  Created by Infinum Infinum on 04.08.2021..
//

import Foundation
import Alamofire

final class UserService {
    
    static func getCurrentUser(onSuccess: @escaping (_ response: DataResponse<UserResponse, AFError>) -> Void) {
        APIManager.shared.request(
            endpoint: UserRoute.getCurrentUser,
            responseDecodableType: UserResponse.self,
            succsessHandler: onSuccess
        )
    }
}
