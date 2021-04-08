//
//  ViewController.swift
//  ImageGallery
//
//  Created by Alon Reik on 07/04/2021.
//

import UIKit


/// UICollectionViewController implements the UICollectionViewDelegate & UICollectionViewDataSource protocols.
class ImageGalleryViewController: UICollectionViewController {
    
    /* ---------
     Constants
    ----------- */
    
    private let reusableCellIDForImages = "ImageCell"
    
    
    // The Model: An array of urls (of string of urls that lead to images). (first is an emoji)
    let imagesURLs = [
        "https://i.pinimg.com/originals/03/7e/79/037e79b2fb52127537be79110891ae3f.png",
        "https://media.bleacherreport.com/f_auto,w_800,h_533,q_auto,c_fill/br-img-images/003/872/788/hi-res-2c4869a446d305ffae628b510cb6131f_crop_north.jpg",
        "https://static01.nyt.com/images/2020/06/12/sports/12nba-return/merlin_168451203_493eb598-93f6-47dc-9140-c8bd94b620da-superJumbo.jpg?quality=90&auto=webp",
        "https://swordstoday.ie/wp-content/uploads/2021/03/getobject-47-e1575408347332-770x462.jpeg"
    ]
    
    //
    var cellWidth = 50.0
    
    /* -------------------------------------------------
     Methods for the UICollectionViewDataSource Protocol
    ---------------------------------------------------- */
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get the cell at the given indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellIDForImages, for: indexPath)
        
        // Downcast the cell item to a derived class (derived from CollectionViewCell)
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            // set the URL var of the imageCell
            imageCell.imageURL = URL(string: imagesURLs[indexPath.item])
            return imageCell
        } else {
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let imageCell = collectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell {
            return CGSize(width: cellWidth, height: Double(imageCell.aspectRatio) * cellWidth)
        } else {
            print("fdfd \n")
            return CGSize(width: cellWidth, height: cellWidth)
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

