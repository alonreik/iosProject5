import UIKit

// todo - what do we do when we try to fetch an image but fail?

class ImageGalleryTableViewController: UITableViewController {
    
    // the model (for this MVC):
    var galleryNames = ["NBA", "Euroleague"]
    var deletedGalleries: [String] = []
    var moreGalleryName = ["G League", "La Liga" ,"French League", "Winner League"]
    
    private let URLs = ["https://media.bleacherreport.com/f_auto,w_800,h_533,q_auto,c_fill/br-img-images/003/872/788/hi-res-2c4869a446d305ffae628b510cb6131f_crop_north.jpg", "https://static01.nyt.com/images/2020/06/12/sports/12nba-return/merlin_168451203_493eb598-93f6-47dc-9140-c8bd94b620da-superJumbo.jpg?quality=90&auto=webp", "https://swordstoday.ie/wp-content/uploads/2021/03/getobject-47-e1575408347332-770x462.jpeg",
        "https://static.timesofisrael.com/www/uploads/2019/07/AP_18337090034812-e1563112655347.jpg",
        "https://a.espncdn.com/combiner/i?img=/i/headshots/nba/players/full/996.png&w=350&h=254",
        "https://basket.co.il/pics/2019/2020/14ob21.jpg",
        "https://external-preview.redd.it/WRyCAB2n7HQQURRTNIc6OkC58swUT1CxbIYhBh900DQ.jpg?auto=webp&s=57f10a7cbba40c7758d9b7e1576a3ce98122d623"
    ]
    
    lazy private var models = [
        "NBA": [ImageGalleryItem(url: self.URLs[0]), ImageGalleryItem(url: self.URLs[1]), ImageGalleryItem(url: self.URLs[2]), ImageGalleryItem(url: self.URLs[6])],
        "Euroleague": [ImageGalleryItem(url: self.URLs[3]), ImageGalleryItem(url: self.URLs[4]),ImageGalleryItem(url: self.URLs[5])]
    ]

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ImageGalleryTableViewCell, let rowName = cell.textLabel?.text, let destinationGallery = models[rowName] {
            if segue.identifier == "Choose Gallery" {
                if let destination = segue.destination as? ImageGalleryCollectionViewController {
                    // set the image gallery to be the appropiate array of Image instances.
                    destination.imageGallery = destinationGallery
                    // set the title of the segue.destination to be name of the picked gallery.
                    destination.title = rowName
                }
            }
        }
    }
    
    /* -------------------
     Functions for Buttons
     ---------------------*/
    
    @IBAction func addGallery(_ sender: Any) {
        guard let galleryName = self.moreGalleryName.popLast() else {
            print("out of gallery names")
            return
        }
        galleryNames.append(galleryName)
        tableView.performBatchUpdates({
            if (galleryNames.count == 1){
                tableView.insertSections([0], with: .automatic)
            }
            tableView.insertRows(at: [IndexPath(row: galleryNames.count - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }
    
    
    /* -------------------
     Tableview data source methods
     ---------------------*/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // There are 2 sections: one for the gallery names, and one for the deleted galleries names.
        // If no gallery is currently in the deleted galleries section, then only 1 section is displayed.
        if deletedGalleries.count == 0 && galleryNames.count == 0 {
            return 0
        } else if deletedGalleries.count == 0 || galleryNames.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if galleryNames.count > 0 && section == 0 {
            return self.galleryNames.count
        } else { // if section == 1
            return deletedGalleries.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        if let galleryTableCell = cell as? ImageGalleryTableViewCell {
            galleryTableCell.textLabel?.text = (galleryNames.count > 0 && indexPath.section == 0) ? galleryNames[indexPath.row] : deletedGalleries[indexPath.row]
            return galleryTableCell
        } else { //if the downcasting failed, returns a generic collection view cell.
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Pressing a tableView row will segue to the gallery only if the gallery-name is not in the deleted section.
        if galleryNames.count > 0 && indexPath.section == 0 {
            performSegue(withIdentifier: "Choose Gallery", sender: tableView.cellForRow(at: indexPath))
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if galleryNames.count > 0 && section == 0 {
            return "Gallery Names"
        } else {
            return "Recently Deleted"
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if galleryNames.count > 0 && indexPath.section == 0 {
                let galleryName = galleryNames[indexPath.row]
                tableView.performBatchUpdates({
                    galleryNames.remove(at: indexPath.row)
                    deletedGalleries.append(galleryName)
                    if (deletedGalleries.count == 1) {
                        // If we need to create the second section:
                        tableView.insertSections([1], with: .automatic)
                    } else if (galleryNames.isEmpty) {
                        // If we need to delete the first section
                        tableView.deleteSections([0], with: .automatic)
                    }
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.insertRows(at: [IndexPath(row: deletedGalleries.count - 1, section: galleryNames.isEmpty ? 0 : 1)], with: .automatic)
                }, completion: nil)
            } else {
                tableView.performBatchUpdates({
                    deletedGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    if (deletedGalleries.count == 0) {
                        tableView.deleteSections([indexPath.section], with: .automatic)
                    }
                }, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (galleryNames.count > 0 && indexPath.section == 0) {
            return nil
        }
        var actions: [UIContextualAction] = []
        let recoverAction = UIContextualAction(style: .normal, title: "Undelete") { (action, view, _) in
            let deletedGallery = self.deletedGalleries[indexPath.row]
            self.deletedGalleries.remove(at: indexPath.row)
            self.galleryNames.append(deletedGallery)
            tableView.performBatchUpdates({
                if (self.galleryNames.count == 1) {
                    tableView.insertSections([0], with: .automatic)
                } else if (self.deletedGalleries.count == 0) {
                    tableView.deleteSections([self.galleryNames.isEmpty ? 0 : 1], with: .automatic)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [IndexPath(row: self.galleryNames.count - 1, section: 0)], with: .automatic)
            }, completion: nil)
        }

        actions.append(recoverAction)
        return UISwipeActionsConfiguration(actions: actions)
    }
}
