//
//  ViewController.swift
//  ImageGallery
//
//  Created by Alon Reik on 07/04/2021.
//

import UIKit


/// UICollectionViewController implements the UICollectionViewDelegate & UICollectionViewDataSource protocols.
class ImageGalleryViewController: UICollectionViewController {

    // The Model: An array of urls (of images). (first is an emoji)
    let imagesURLs = [
        "https://i.pinimg.com/originals/03/7e/79/037e79b2fb52127537be79110891ae3f.png",
//        "https://media.bleacherreport.com/f_auto,w_800,h_533,q_auto,c_fill/br-img-images/003/872/788/hi-res-2c4869a446d305ffae628b510cb6131f_crop_north.jpg",
        "https://static01.nyt.com/images/2020/06/12/sports/12nba-return/merlin_168451203_493eb598-93f6-47dc-9140-c8bd94b620da-superJumbo.jpg?quality=90&auto=webp",
        "https://swordstoday.ie/wp-content/uploads/2021/03/getobject-47-e1575408347332-770x462.jpeg"
    ]
    
    
    var imageView = UIImageView()
    
    
    // How many sections in the collection view??
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath)
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            imageCell.imageURL = URL(string: imagesURLs[indexPath.item])
            return imageCell
        } else {
            return cell
        }
    }
    
    // how many items per section?
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

