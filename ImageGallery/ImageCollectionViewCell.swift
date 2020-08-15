//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Isaac on 8/10/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    private var cellImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
     //       scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    //@IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var scrollView: UIScrollView! {
//        didSet {
//            scrollView.minimumZoomScale = 1/25
//            scrollView.maximumZoomScale = 1.0
//            scrollView.delegate = self
//            scrollView.addSubview(imageView)
//
//        }
//    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
    
    private func fetchImage() {
        //print("got image")
        if let url = imageURL {
            //           do {
            //reseting image
            imageView.image = nil
            spinner.isHidden = false
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.cellImage = UIImage(data: imageData)
                    }
                }
            }
            
            //            } catch let error {
            //
            //            }
        }
    }
    
    
}
