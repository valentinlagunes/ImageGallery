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
    var galleries = [String: ImageCollection]()
    
    // MARK: - Table view data source
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return galleryDocuments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTitle", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text =  galleryDocuments[indexPath.row]
        //if we haven't saved the data for this table row yet
        if galleries[(cell.textLabel?.text)!] == nil {
            galleries[(cell.textLabel?.text)!] = ImageCollection()
        }
        return cell
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
            // Delete the row from the data source
            galleryDocuments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    override func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        let cell = tableView.cellForRow(at: didSelectRowAt)
        performSegue(withIdentifier: "gallerySegue", sender: cell)
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
        if let cell = sender as? UITableViewCell
        {
            if let destination = segue.destination as? ImageGalleryViewController {
                destination.imageCollection.images = galleries[(cell.textLabel?.text)!]!.images
                
            }
        }
        
    }
    

}

