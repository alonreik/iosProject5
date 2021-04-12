//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Alon Reik on 12/04/2021.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell {

    var inRecentlyDeleted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        // define a swipe-left recognizer and add it to any ImageGalleryTableViewCell's gesture recognizers.
//        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(recognizer:)))
//        swipeRecognizer.direction = [.left]
//        addGestureRecognizer(swipeRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc private func swipeHandler(recognizer: UISwipeGestureRecognizer){
//        switch recognizer.direction {
//        case .left:
//            inRecentlyDeleted = true
//            print("swiped left")
//        default:
//            break
//        }
//    }
}
