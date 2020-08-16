//
//  GalleryTableViewController.swift
//  ImageGallery
//
//  Created by Isaac on 8/11/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    
    var galleryDocuments = ["One", "Two", "Three"]
    var deletedDocuments = [String]()
    var galleries = [String: ImageCollection]()
    var recentlyDeletedGalleries = [String: ImageCollection]()
    var currentIndexPath : IndexPath?
    
    // MARK: - Table view data source
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentIndexPath == nil {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: firstIndexPath)
            currentIndexPath = firstIndexPath
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        if section == 0 {
            return "Image Galleries"
        }
        else {
            return "Recently Deleted"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return galleryDocuments.count
        } else{
            return recentlyDeletedGalleries.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTitle", for: indexPath) as? GalleryTitleCell
        {
            if cell.parentTableView == nil {
                cell.parentTableView = self
            }
            // Configure the cell...
            if indexPath.section == 0
            {
                cell.textField.text = galleryDocuments[indexPath.row]
                //cell.textLabel?.text =  galleryDocuments[indexPath.row]
                //if we haven't saved the data for this table row yet
                if galleries[cell.textField.text!] == nil {
                    galleries[cell.textField.text!] = ImageCollection()
                }
            }
            else
            { //recently deleted
                cell.textField.text = deletedDocuments[indexPath.row]
            }
            return cell
        }
        else //should never actually get here
        {
            return tableView.dequeueReusableCell(withIdentifier: "GalleryTitle", for: indexPath)
        }
        
    }
    
    @IBAction func newGallery(_ sender: UIBarButtonItem) {
        let newTitle = "Untitled".madeUnique(withRespectTo: galleryDocuments)
        galleryDocuments += [newTitle]
        galleries[newTitle] = ImageCollection()
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source and add it to recently deleted
            if indexPath.section == 0
            {
                tableView.performBatchUpdates({
                    let deletedGalleryName = galleryDocuments.remove(at: indexPath.row)
                    deletedDocuments.insert(deletedGalleryName, at: deletedDocuments.count)
                    let deletedGalleryDict = galleries.remove(at: galleries.index(forKey: deletedGalleryName)!)
                    recentlyDeletedGalleries[deletedGalleryDict.key] = deletedGalleryDict.value
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    let newIndexPath = IndexPath(row: recentlyDeletedGalleries.count - 1, section: 1)
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                })
                //default to first imagegallery
                let firstIndexPath = IndexPath(row: 0, section: 0)
                self.tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .none)
                self.tableView(tableView, didSelectRowAt: firstIndexPath)
            }
            else //deleting something from recently deleted permanently
            {
                tableView.performBatchUpdates({
                    let deletedGalleryName = deletedDocuments.remove(at: indexPath.row)
                    recentlyDeletedGalleries.remove(at: recentlyDeletedGalleries.index(forKey: deletedGalleryName)!)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }
        else //undelete a recently deleted gallery
        {
            let swipeAction = UIContextualAction(style: .normal,
                                                 title: "UNDO",
                                                 handler: { (contextAction, sourceView, completionHandler) in
                                                    tableView.performBatchUpdates({
                                                        let oldGalleryName = self.deletedDocuments.remove(at: indexPath.row)
                                                        self.galleryDocuments.insert(oldGalleryName, at: self.galleryDocuments.count)
                                                        let oldGalleryDict = self.recentlyDeletedGalleries.remove(at: self.recentlyDeletedGalleries.index(forKey: oldGalleryName)!)
                                                        self.galleries[oldGalleryDict.key] = oldGalleryDict.value
                                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                                        let newIndexPath = IndexPath(row: self.galleries.count - 1, section: 0)
                                                        tableView.insertRows(at: [newIndexPath], with: .fade)
                                                    })
                                                    completionHandler(true)
                                                    
            })
            return UISwipeActionsConfiguration(actions: [swipeAction])
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 { //can't actually select deleted row
            return nil
        }
        else
        {
            return indexPath
        }
    }
    
    override func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        if didSelectRowAt.section == 1 { //can't select recently deleted galleries
            return
        }
        else
        {
            currentIndexPath = didSelectRowAt
            let cell = tableView.cellForRow(at: didSelectRowAt)
            performSegue(withIdentifier: "gallerySegue", sender: cell)
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
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let cell = sender as? GalleryTitleCell
        {
            //my imagegallery controller is embedded in
            //nav controller, so have to go through
            //this extra step
            if let nav = segue.destination as? UINavigationController{
                
                if let destination = nav.topViewController as? ImageGalleryViewController {
                    destination.imageCollection = galleries[(cell.textField.text)!]!
                    
                }
            }
        }
        
    }
    
    
}

