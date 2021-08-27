//
//  TVShowDetailsTableCellView.swift
//  TV Shows
//
//  Created by Infinum Infinum on 26.07.2021..
//

import Foundation
import UIKit
import Kingfisher

class TVShowDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tvShowDescriptionLabel: UILabel!
    @IBOutlet private var ratingView: RatingView!
    @IBOutlet private weak var totalAndAverageReviewLabel: UILabel!
    @IBOutlet private weak var showImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tvShowDescriptionLabel.text = ""
        totalAndAverageReviewLabel.text = ""
        ratingView.isEnabled = false
    }
    
    func configure(show: Show) {
        tvShowDescriptionLabel.text = show.description
        totalAndAverageReviewLabel.text = String(show.numberOfReviews) + " REVIEWS, " + String(show.averageRating) + " AVERAGE"
        ratingView.setRoundedRating(show.averageRating)
        guard let imageUrl = show.imageUrl else {
            showImage.image = UIImage(named: "ic-show-placeholder-vertical")
            return
        }
        ImageManager.shared.getImage(
            imageView: showImage,
            imageUrl: URL(string: imageUrl),
            placeholderImage: UIImage(named: "ic-show-placeholder-vertical")
        )
    }
    
}
