//
//  ReviewsService.swift
//  TV Shows
//
//  Created by Infinum Infinum on 27.07.2021..
//

import Foundation
import Alamofire

class ReviewsService {
    
    static func getReviews (showId: String, page: Int?, items: Int?, onSuccess: @escaping (_ response: DataResponse<ReviewsResponse, AFError>) -> Void) {
        APIManager.shared.request(
            endpoint: ReviewsRoute.getReviews(showId: showId, page: page, items: items),
            responseDecodableType: ReviewsResponse.self,
            succsessHandler: onSuccess
        )
    }
    
}
