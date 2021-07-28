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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewersEmailLabel.text = ""
        reviewLabel.text = ""
    }
    
    func configure(review: Review?){
        reviewersEmailLabel.text = review?.user.email
        reviewLabel.text = review?.comment
    }
    
}
