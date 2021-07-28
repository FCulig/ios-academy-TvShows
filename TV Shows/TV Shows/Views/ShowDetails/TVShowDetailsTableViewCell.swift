//
//  TVShowDetailsTableCellView.swift
//  TV Shows
//
//  Created by Infinum Infinum on 26.07.2021..
//

import Foundation
import UIKit

class TVShowDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tvShowDescriptionLabel: UILabel!
    @IBOutlet private var ratingView: RatingView!
    @IBOutlet private weak var totalAndAverageReviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tvShowDescriptionLabel.text = ""
        totalAndAverageReviewLabel.text = ""
        ratingView.isEnabled = false
    }
    
    func configure(show: Show){
        tvShowDescriptionLabel.text = show.description
        totalAndAverageReviewLabel.text = String(show.numberOfReviews) + " REVIEWS, " + String(show.averageRating) + " AVERAGE"
        ratingView.setRoundedRating(show.averageRating)
    }
    
}
