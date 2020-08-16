//
//  GalleryTitleCell.swift
//  ImageGallery
//
//  Created by Isaac on 8/15/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class GalleryTitleCell: UITableViewCell, UITextFieldDelegate {
    weak var parentTableView : GalleryTableViewController?
    
    private var oldTitleForEditing : String?
    
    @IBOutlet weak var textField: UITextField!{
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(beginTyping))
            tap.numberOfTapsRequired = 2
            addGestureRecognizer(tap)
            textField.delegate = self
        }
    }
    
    @objc func beginTyping() {
        oldTitleForEditing = textField.text
        textField.isEnabled = true
        print("called beginTyping")
        textField.becomeFirstResponder()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isEnabled = false
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        var oldIndex : Array<String>.Index?
        if parentTableView?.galleries[oldTitleForEditing ?? ""] != nil
        {
            oldIndex = parentTableView?.galleryDocuments.firstIndex(of: oldTitleForEditing!)
            parentTableView?.galleryDocuments.remove(at: oldIndex!)
            parentTableView?.galleryDocuments.insert(textField.text!, at: oldIndex!)
            parentTableView?.galleries.change(thisKey: oldTitleForEditing!, to: textField.text!)
        }
        else if parentTableView?.recentlyDeletedGalleries[oldTitleForEditing ?? ""] != nil
        {
            oldIndex = parentTableView?.deletedDocuments.firstIndex(of: oldTitleForEditing!)
            parentTableView?.deletedDocuments.remove(at: oldIndex!)
            parentTableView?.deletedDocuments.insert(textField.text!, at: oldIndex!)
            parentTableView?.recentlyDeletedGalleries.change(thisKey: oldTitleForEditing!, to: textField.text!)
        }
    }

}

extension Dictionary
{
    //short functions to switch keys quickly, doesn't have any guards though
    mutating func change(thisKey: Key, to: Key) {
        let oldValue = remove(at: index(forKey: thisKey)!)
        self[to] = oldValue.value
    }
}
