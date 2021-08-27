//
//  TVShowReviewTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Infinum on 26.07.2021..
//

import Foundation
import UIKit

class TVShowReviewTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var reviewersEmailLabel: UILabel!
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var profileImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewersEmailLabel.text = ""
        reviewLabel.text = ""
        profileImage.image = UIImage(named: "ic-profile-placeholder")
    }
    
    func configure(review: Review) {
        reviewersEmailLabel.text = review.user.email
        reviewLabel.text = review.comment
        guard let imageUrl = review.user.imageUrl else {
            profileImage.image = UIImage(named: "ic-show-placeholder-vertical")
            return
        }
        ImageManager.shared.getImage(
            imageView: profileImage,
            imageUrl: URL(string: imageUrl),
            placeholderImage: UIImage(named: "ic-show-placeholder-vertical")
        )
    }
    
}
