//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Infinum on 24.07.2021..
//

import UIKit

class TVShowTableViewCell: UITableViewCell {

    @IBOutlet private weak var showTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showTitleLabel.text = ""
    }
    
    func configure(show: Show){
        showTitleLabel.text = show.title
    }
    
}
