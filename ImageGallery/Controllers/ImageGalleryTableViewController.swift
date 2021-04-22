//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Alon Reik on 12/04/2021.
//

import UIKit

// todo - what do we do when we try to fetch an image but fail?

class ImageGalleryTableViewController: UITableViewController {

    // the model (for this MVC):
    var galleryNames = ["NBA", "Euroleague"]
    
    var deletedGalleries: [String] = []
    
    // todo - design wise, is it reasonable to include the model of another MVC (the Image class) in the controller of this MVC?.
    private let models = [
                [   // array of image instances (images of NBA players)
                    Image(url: "https://media.bleacherreport.com/f_auto,w_800,h_533,q_auto,c_fill/br-img-images/003/872/788/hi-res-2c4869a446d305ffae628b510cb6131f_crop_north.jpg"),
                    Image(url: "https://static01.nyt.com/images/2020/06/12/sports/12nba-return/merlin_168451203_493eb598-93f6-47dc-9140-c8bd94b620da-superJumbo.jpg?quality=90&auto=webp"),
                    Image(url: "https://swordstoday.ie/wp-content/uploads/2021/03/getobject-47-e1575408347332-770x462.jpeg"),
                ],
                [   // array of image instances (images of euroleague players)
                    Image(url: "https://static.timesofisrael.com/www/uploads/2019/07/AP_18337090034812-e1563112655347.jpg"),
                    Image(url: "https://a.espncdn.com/combiner/i?img=/i/headshots/nba/players/full/996.png&w=350&h=254"),
                    Image(url: "https://basket.co.il/pics/2019/2020/14ob21.jpg"),
                ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // How many sections in the tableview?
    override func numberOfSections(in tableView: UITableView) -> Int {
        // There are 2 sections: one for the gallery names, and one for the deleted galleries names.
        // If no gallery is currently in the deleted galleries section, then only 1 section is displayed.
//        if deletedGalleries.count == 0 && galleryNames.count == 0 {
//            return 0
//        } else if deletedGalleries.count == 0 || galleryNames.count == 0 {
//            return 1
//        } else {
//            return 2
//        }
        return 2
    }
    
    // How many rows per section in the tableview?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return galleryNames.count
        } else { // if section == 1
            return deletedGalleries.count
        }
    }

    // What do display in each row\cell of the table view?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        if let galleryTableCell = cell as? ImageGalleryTableViewCell {
            galleryTableCell.textLabel?.text = (indexPath.section == 0) ? galleryNames[indexPath.row] : deletedGalleries[indexPath.row]
            return galleryTableCell
        } else { //if the downcasting failed, returns a generic collection view cell.
            return cell
        }
    }
    
    // What happens when somebody selects a row? preforms segue.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Pressing a tableView row will segue to the gallery only if the gallery-name is not in the deleted section.
        if indexPath.section == 0 {
            performSegue(withIdentifier: "Choose Gallery", sender: tableView.cellForRow(at: indexPath))
        }
    }
    
    //
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Gallery Names": "Recently Deleted"
    }

//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let galleryName = galleryNames[indexPath.row]
                // remove
                galleryNames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)

                // move the gallery name to deleted
                deletedGalleries.append(galleryName)
            } else if indexPath.section == 1 {
                deletedGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.section == 1 else {
            return nil
        }
        var actions: [UIContextualAction] = []
        let recoverAction = UIContextualAction(style: .normal, title: "Undelete") { (action, view, _) in
            let deletedGallery = self.deletedGalleries[indexPath.row]
            
            self.deletedGalleries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            self.galleryNames.append(deletedGallery)
            
            tableView.reloadData()
            }
        actions.append(recoverAction)
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
            if segue.identifier == "Choose Gallery" {
                if let destination = segue.destination as? ImageGalleryCollectionViewController {
                    // set the image gallery to be the appropiate array of Image instances.
                    destination.imageGallery = models[indexPath.row]
                    // set the title of the segue.destination to be name of the picked gallery.
                    destination.title = galleryNames[indexPath.row]
                }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
