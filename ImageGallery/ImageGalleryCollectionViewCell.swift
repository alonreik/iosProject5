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
    
    var imageURL: URL? {
        
        didSet {
            imageView.image = nil
            fetchImage()
            
            // A view that appears on the screen has a window variable
            if window != nil {
                // the condition above means: "Am I on screen?"
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeThatFits(bounds.size)
            spinner?.stopAnimating()
        }
    }

    private func fetchImage() {
        
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // why weak self? in case the task\block takes too long to run and the user gave up on it and switched to
                // another view controller, the line with "self" will make the view to stay on the heap.
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    // the second condition belows makes sure that the url is the one I asked for (because it may be changed during context switches)
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
