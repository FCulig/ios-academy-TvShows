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
    
    static func postReview (rating: Int, comment: String, showId: String, onSuccess: @escaping (_ response: DataResponse<ReviewResponse, AFError>) -> Void) {
        APIManager.shared.request(
            endpoint: ReviewsRoute.postReview(rating: rating, comment: comment, showId: showId),
            responseDecodableType: ReviewResponse.self,
            succsessHandler: onSuccess
        )
    }
    
}
