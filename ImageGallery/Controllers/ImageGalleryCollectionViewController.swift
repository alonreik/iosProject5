//
//  ViewController.swift
//  ImageGallery
//
//  Created by Alon Reik on 07/04/2021.
//

import UIKit

// todo - notice that estimated size in collection view is none

/// UICollectionViewController implements the UICollectionViewDelegate & UICollectionViewDataSource protocols.
class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /* ---------
     Constants
    ----------- */
    
    // todo
    private let reusableCellIDForImages = "ImageCell"
    
    // The Model: An array of Image instances (Image is a custom class for this ex).
    var imageGallery: [Image] = []
    
//        Image(url: "https://i.pinimg.com/originals/03/7e/79/037e79b2fb52127537be79110891ae3f.png"),
//        Image(url: "https://media.bleacherreport.com/f_auto,w_800,h_533,q_auto,c_fill/br-img-images/003/872/788/hi-res-2c4869a446d305ffae628b510cb6131f_crop_north.jpg"),
//        Image(url: "https://static01.nyt.com/images/2020/06/12/sports/12nba-return/merlin_168451203_493eb598-93f6-47dc-9140-c8bd94b620da-superJumbo.jpg?quality=90&auto=webp"),
//        Image(url: "https://swordstoday.ie/wp-content/uploads/2021/03/getobject-47-e1575408347332-770x462.jpeg"),
//    ]
    
    /* ---------
     Properties
    ----------- */
    
    private var maximalWidth: CGFloat {
        // todo - arbitrary maximal width
        return collectionView.frame.size.width - 10
    }
    
    private var minimalWidth: CGFloat {
        // todo - arbitrary minimal width
        return collectionView.frame.size.width / 10
    }
    
    private lazy var cellWidth: CGFloat = 100.0
    
    // The collectionView's flow layout.
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

