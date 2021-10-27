import Foundation

class ImageGalleryItem
{
    var url: URL?
    var aspectRatio: Double = 0
    
    init(url: String) {
        if let validURL = URL(string: url) {
            self.url = validURL
        }
    }
}
