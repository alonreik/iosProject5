//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Alon Reik on 12/04/2021.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // define a swipe down recognized
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(recognizer:)))
        swipeRecognizer.direction = [.left]
        addGestureRecognizer(swipeRecognizer)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func swipeHandler(recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .left:
            print("swiped left")
        default:
            break
        }
    }
}
