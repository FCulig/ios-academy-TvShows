//
//  TvShowService.swift
//  TV Shows
//
//  Created by Infinum Infinum on 24.07.2021..
//

import Foundation
import Alamofire

class ShowsService {
    
    static func getShows (page: Int?, items: Int?, onSuccess: @escaping (_ response: DataResponse<ShowsResponse, AFError>) -> Void) {
        APIManager.shared.request(
            endpoint: ShowsRoute.getShows(page: page, items: items),
            responseDecodableType: ShowsResponse.self,
            succsessHandler: onSuccess
        )
    }
    
}
