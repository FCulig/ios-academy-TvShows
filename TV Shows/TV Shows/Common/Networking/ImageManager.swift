//
//  ImageManager.swift
//  TV Shows
//
//  Created by Infinum Infinum on 04.08.2021..
//

import Foundation
import Kingfisher

final class ImageManager {
    
    // MARK: - Lets and vars

    static let shared = ImageManager()

    // MARK: - Initializer
    
    private init() { }
    
    func getImage(imageView: UIImageView, imageUrl: URL?, placeholderImage: UIImage?) {
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage
        )
    }
    
}
