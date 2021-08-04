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
    
    static func updateProfileImage(image: Data, email: String, onSuccess: @escaping (_ response: DataResponse<UserResponse, AFError>) -> Void) {
        let requestData = MultipartFormData()
        requestData.append(
            image,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        requestData.append(email.data(using: .utf8)!, withName: "email")
        APIManager.shared.upload(
            data: requestData,
            url: UserRoute.updateProfileImage.baseURL + UserRoute.updateProfileImage.path,
            responseDecodableType: UserResponse.self,
            succsessHandler: onSuccess
        )
    }
}
