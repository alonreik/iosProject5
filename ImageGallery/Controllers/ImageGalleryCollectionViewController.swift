import UIKit

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /* Class Variables */
    
    private let reusableCellIDForImages = "ImageCell"
    
    // The Model (for this MVC): An array of Image instances.
    var imageGallery: [ImageGalleryItem] = []
    
    private var moreURLS = [
        "https://picsum.photos/id/237/200/300",
        "https://i.picsum.photos/id/1012/3973/2639.jpg?hmac=s2eybz51lnKy2ZHkE2wsgc6S81fVD1W2NKYOSh8bzDc",
        "https://i.picsum.photos/id/1011/5472/3648.jpg?hmac=Koo9845x2akkVzVFX3xxAc9BCkeGYA9VRVfLE4f0Zzk",
        "https://i.picsum.photos/id/1024/1920/1280.jpg?hmac=-PIpG7j_fRwN8Qtfnsc3M8-kC3yb0XYOBfVzlPSuVII",
        "https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
    ]
    
    // Arbitrary Maximal Width
    private var maximalWidth: CGFloat {
        return collectionView.frame.size.width - 10
    }
    
    // Arbitrary minimal Width
    private var minimalWidth: CGFloat {
        return collectionView.frame.size.width / 10
    }
    
    private lazy var cellWidth: CGFloat = 100.0
    
    // The collectionView's flow layout. This var is used to trigger a layout update
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    /* Class Methods */
    
    
    /* -------------------
     Functions for Buttons
     ---------------------*/
    
    @IBAction func addRandomImage(_ sender: Any) {
        guard let newImage = moreURLS.popLast() else {
            return
        }
        let newImageItem = ImageGalleryItem(url: newImage);
        let newImageItemIndex = imageGallery.count;
        imageGallery.append(newImageItem);
        collectionView.insertItems(at: [IndexPath(item: newImageItemIndex, section: 0)])
    }
    
    /* ------------------------------------
        UICollectionViewDataSource Methods
     --------------------------------------- */
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get the cell at the given indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reusableCellIDForImages, for: indexPath)
        
        // Downcast the cell item to a derived class (derived from CollectionViewCell)
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            imageCell.toggleActivitySpinner()
            // get the URL (of an image) from the model
            if let url = imageGallery[indexPath.item].url {
                // Get a global "background" queue/thread to perform non UI tasks (getting data from url):
                DispatchQueue.global(qos: .userInitiated).async {
                    let urlContents = try? Data(contentsOf: url)
                    // Get the main queue to perform UI tasks (using activity spinner and setting an image):
                    DispatchQueue.main.async {
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
     ViewControllers Life Cycle Methods
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

