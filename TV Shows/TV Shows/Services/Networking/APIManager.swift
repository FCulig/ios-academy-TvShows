//
//  APIManager.swift
//  TV Shows
//
//  Created by Infinum Infinum on 21.07.2021..
//

import Foundation
import Alamofire
import SVProgressHUD

final class APIManager {
    
    // MARK: - Lets and vars

    static let shared = APIManager()
    var headers: AuthInfo?

    // MARK: - Initializer
    
    private init() { }
    
    func request<T: Decodable>(
        url: String,
        parameters: [String: String],
        method: HTTPMethod,
        responseDecodableType: T.Type,
        succsessHandler: @escaping (_ response: DataResponse<T, AFError>) -> Void
        //errorHandler: @escaping (_ response: AFError) -> Void
    ) {
        AF
            .request(
                url,
                method: method,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: responseDecodableType) { dataResponse in
                switch dataResponse.result {
                case .success(_):
                    succsessHandler(dataResponse)
                case .failure(let error):
                    print(error)
                    //errorHandler(error)
                    SVProgressHUD.showError(withStatus: "Ooops something went wrong...")
                }
            }
    }
}
