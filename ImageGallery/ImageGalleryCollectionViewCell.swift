//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Alon Reik on 08/04/2021.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Depends on the spinner's state, this function stops the spinner's animation
    // and hides the spinner's view, or performs the opposite.
    func toggleActivitySpinner() {
        switch spinner.isAnimating {
        case true:
            spinner?.stopAnimating()
            spinner?.isHidden = true
        case false:
            spinner?.isHidden = false
            spinner?.startAnimating()
        }
    }
}
