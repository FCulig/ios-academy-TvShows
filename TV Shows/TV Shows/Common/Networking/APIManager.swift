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
        endpoint: EndPointType,
        responseDecodableType: T.Type,
        succsessHandler: @escaping (_ response: DataResponse<T, AFError>) -> Void
    ) {
        AF
            .request(endpoint)
            .validate()
            .responseDecodable(of: responseDecodableType) { dataResponse in
                switch dataResponse.result {
                case .success(_):
                    succsessHandler(dataResponse)
                case .failure(let error):
                    print(error)
                    SVProgressHUD.showError(withStatus: "Ooops something went wrong...")
                }
            }
    }
}
