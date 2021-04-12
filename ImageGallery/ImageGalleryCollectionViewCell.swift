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
    
    // todo?
//    var aspectRatio: CGFloat = 0.0
    
    // The data source for the imageView. If this var isn't nil, the imageView attempts to parse and present the content of it.
//    var imageURL: URL? {
//        didSet {
            // when someone sets the imageURL, the app "deletes" the former image from the image view:
//            imageView.image = nil
            // and attempts to fetch a new image using the new url:
//            fetchImage()
//        }
//    }
//
//    // "An alias" for the imageView's image property. It is stored as a private property in order to allow making
//    // custom configurations and actions (such as presenting a spinner while loading) before displaying a new image.
//    var image: UIImage? {
//        get {
//            return imageView.image
//        }
//        set {
//            // This closure is meant to be triggered by "fetchImage" on the main thread.
//            imageView.image = newValue
//            toggleActivitySpinner()
//        }
//    }

    // Uses the imageURL variable to send a URL request and get a response (this is done on a non-main thread),
    // and then attempts to parse the URL response to a UIImage instance (this is done on the main thread)
//    private func fetchImage() {
//        guard let url = imageURL else {
//            return
//        }
//        // Get a global "background" queue to perform non UI tasks (getting data from url):
//        DispatchQueue.global(qos: .userInitiated).async {
//            let urlContents = try? Data(contentsOf: url)
//            // Get the main queue to perform a UI task:
//            DispatchQueue.main.async {
//                self.toggleActivitySpinner()
//                // the second condition below makes sure that the url is the one I asked for
//                // (because the url var may be changed during context switches between the main and other threads\queues)
//                if let imageData = urlContents, url == self.imageURL {
//                    self.image = UIImage(data: imageData)
//                }
//            }
//        }
//    }
    
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
