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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tvShowDescriptionLabel.text = ""
    }
    
    func configure(show: Show?){
        tvShowDescriptionLabel.text = show?.description
    }
    
}
