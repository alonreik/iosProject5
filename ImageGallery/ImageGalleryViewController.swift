//
//  ViewController.swift
//  ImageGallery
//
//  Created by Alon Reik on 07/04/2021.
//

import UIKit

// todo - notice that estimated size in collection view is none

/// UICollectionViewController implements the UICollectionViewDelegate & UICollectionViewDataSource protocols.
class ImageGalleryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /* ---------
     Constants
    ----------- */
    
    // todo
    private let reusableCellIDForImages = "ImageCell"
    
    // The Model: An array of urls (of string of urls that lead to images). (first is an emoji)
    let imagesModelArray = [
//        imageModel(url: "https://i.pinimg.com/originals/03/7e/79/037e79b2fb52127537be79110891ae3f.png"),
        "https://i.pinimg.com/originals/03/7e/79/037e79b2fb52127537be79110891ae3f.png",
//        "https://media.bleacherreport.com/f_auto,w_800,h_533,q_auto,c_fill/br-img-images/003/872/788/hi-res-2c4869a446d305ffae628b510cb6131f_crop_north.jpg",
//        "https://static01.nyt.com/images/2020/06/12/sports/12nba-return/merlin_168451203_493eb598-93f6-47dc-9140-c8bd94b620da-superJumbo.jpg?quality=90&auto=webp",
//        "https://swordstoday.ie/wp-content/uploads/2021/03/getobject-47-e1575408347332-770x462.jpeg"
    ]
    
    private var maximalWidth: CGFloat {
        return collectionView.frame.size.width
    }
    
    private var minimalWidth: CGFloat {
        // todo - arbitrary minimal width
        return collectionView.frame.size.width / 2
    }
    
    //
    private lazy var cellWidth: CGFloat = 100.0
    
    // The collectionView's flow layout.
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
//    shouldIn

    
    /* -------------------------------------------------
     Methods for the UICollectionViewDataSource Protocol
    ---------------------------------------------------- */
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get the cell at the given indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellIDForImages, for: indexPath)
        
        // Downcast the cell item to a derived class (derived from CollectionViewCell)
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            // set the URL var of the imageCell
            
            imageCell.imageURL = URL(string: imagesModelArray[indexPath.item])
//            imageCell.imageURL = imagesModelArray[indexPath.item].imageURL
//            let imageWidth = imageCell.imageView.image?.size.width ?? 0.0
//            let imageHeight = imageCell.imageView.image?.size.height ?? 1.0
//            imagesModelArray[indexPath.item].aspectRatio = Double(imageWidth / imageHeight)
            
            return imageCell
        } else {
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellWidth, height: CGFloat(imagesModelArray[indexPath.item].aspectRatio) * cellWidth)
        if let imageCell = collectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell {
            return CGSize(width: cellWidth, height: imageCell.aspectRatio * cellWidth)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    /* -----------------------------------
     Overriden methods for ViewControllers
    -------------------------------------- */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    

}

