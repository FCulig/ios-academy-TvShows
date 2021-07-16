//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Infinum Infinum on 08.07.2021..
//

import UIKit
import Alamofire

struct User: Codable{
    let id: String
    let email: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case imageUrl = "image_url"
    }
}

struct UserResponse: Codable {
    let user: User
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let params:  [String: String] = [
            "email": "filip.culig@gmail.com",
            "password": "123321"
        ]
        
        AF.request(
            "https://tv-shows.infinum.academy/users/sign_in",
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    print(userResponse.user.email)
                    print(userResponse.user.id)
                    print(userResponse.user.imageUrl)
                case .failure(let error):
                    print(error)
                }
            }
        
        return true
    }


}

