//
//  Image.swift
//  ImageGallery
//
//  Created by Alon Reik on 11/04/2021.
//

import Foundation

class Image
{
    var imageURL: URL?
    var aspectRatio: Double = 0
    
    init(url: String) {
        if let validImageURL = URL(string: url) {
            imageURL = validImageURL
        } else {
            imageURL = nil
        }
    }
}
