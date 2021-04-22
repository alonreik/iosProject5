//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Alon Reik on 12/04/2021.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var galleryName: UITextField! {
        didSet {
            galleryName.delegate = self
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
        // todo
    }
}
