//
//  PhotoViewController.swift
//  InstrumentsTutorial
//
//  Created by Siess, Clement on 8/27/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var flickrPhoto: FlickrPhoto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImage()
    }
    
    func displayImage() {
        flickrPhoto.loadLargeImage { image, error in
            if let photo = image {
                self.imageView.image = photo
            }
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func starButtonPressed(sender: AnyObject) {
        flickrPhoto.isFavourite = !flickrPhoto.isFavourite
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}