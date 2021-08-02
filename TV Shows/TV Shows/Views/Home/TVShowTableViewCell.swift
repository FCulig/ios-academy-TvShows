//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Infinum on 24.07.2021..
//

import UIKit
import Kingfisher

class TVShowTableViewCell: UITableViewCell {

    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var showImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showTitleLabel.text = ""
        showImage.image = UIImage()
    }
    
    func configure(show: Show){
        showTitleLabel.text = show.title
        guard let imageUrl = show.imageUrl else {
            showImage.image = UIImage(named: "ic-show-placeholder-vertical")
            return
        }
        showImage.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "ic-show-placeholder-vertical")
        )
    }
    
}
