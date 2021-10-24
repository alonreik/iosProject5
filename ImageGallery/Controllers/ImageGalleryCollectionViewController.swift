//
//  ViewController.swift
//  ImageGallery
//
//  Created by Alon Reik on 07/04/2021.
//

import UIKit

// todo - notice that estimated size in collection view is none

/// UICollectionViewController implements the UICollectionViewDelegate & UICollectionViewDataSource protocols.
// This controller is controling a view that is embedded in a split view (as the detail).
class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /* ---------
     Constants
    ----------- */
    
    // todo
    private let reusableCellIDForImages = "ImageCell"
    
    // The Model (for this MVC): An array of Image instances (Image is a custom class for this ex).
    // The array is set before performing segues from the masterview of the splitView to the detail
    // (which is the view that this controller controls).
    var imageGallery: [ImageGalleryItem] = []
    
    /* ---------
     Properties
    ----------- */
    
    //
    private var maximalWidth: CGFloat {
        // todo - arbitrary maximal width
        return collectionView.frame.size.width - 10
    }
    //
    private var minimalWidth: CGFloat {
        // todo - arbitrary minimal width
        return collectionView.frame.size.width / 10
    }
    
    //
    private lazy var cellWidth: CGFloat = 100.0
    
    // The collectionView's flow layout. This var is used to trigger a layout update
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    /* -------------------------------------------------
     Methods for the UICollectionViewDataSource Protocol
    ---------------------------------------------------- */
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get the cell at the given indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellIDForImages, for: indexPath)
        
        // Downcast the cell item to a derived class (derived from CollectionViewCell)
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            
            // get the URL (of an image) from the model
            if let url = imageGallery[indexPath.item].url {
                // todo - move the background assignment to the Image model. 
                
                // Get a global "background" queue/thread to perform non UI tasks (getting data from url):
                DispatchQueue.global(qos: .userInitiated).async {
                    let urlContents = try? Data(contentsOf: url)
                    // Get the main queue to perform UI tasks (using activity spinner and setting an image):
                    DispatchQueue.main.async {
                        imageCell.toggleActivitySpinner()
                        if let imageData = urlContents {
                            imageCell.imageView.image = UIImage(data: imageData) // update the view according to the model
                            guard let height = imageCell.imageView.image?.size.height, let width = imageCell.imageView.image?.size.width else {
                                return
                            }
                            self.imageGallery[indexPath.item].aspectRatio = Double(width / height) // updates the model according to the view
                            imageCell.toggleActivitySpinner()
                        }
                    }
                }
            }
            return imageCell
        } else { //if the downcasting failed, returns a generic collection view cell.
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if imageGallery[indexPath.item].aspectRatio != 0 {
            return CGSize(width: cellWidth, height: cellWidth / CGFloat(imageGallery[indexPath.item].aspectRatio))
        } else {
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    /* -----------------------------------
     Overriden methods for ViewControllers
    -------------------------------------- */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a pinch gesture recognizer to the collection view
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(recognizer:)))
        collectionView.addGestureRecognizer(pinchRecognizer)
    }
    
    /* -------------
     Gestures Handlers
    ----------------- */
    
    // This function is called every time a user pinches the screen
    @objc private func pinchHandler(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            let scaledWidth = cellWidth * recognizer.scale
            // set a new cellWidth size only if the scaled width is within bounds:
            if scaledWidth <= maximalWidth && scaledWidth >= minimalWidth {
                cellWidth = scaledWidth
            }
            flowLayout?.invalidateLayout() // Triggers a layout update
            recognizer.scale = 1.0
        default:
            break
        }
    }
}

