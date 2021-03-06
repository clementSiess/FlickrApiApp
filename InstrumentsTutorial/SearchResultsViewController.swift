//
//  SearchResultsViewController.swift
//  InstrumentsTutorial
//
//  Created by Siess, Clement on 8/27/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var searchResults: FlickrSearchResults?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.collectionView != nil) {
            self.collectionView.reloadData()
        }
        
        let resultsCount = searchResults!.searchResults.count
        
        title = "\(searchResults!.searchTerm) (\(resultsCount))"
    }
    
}

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    var flickrPhoto: FlickrPhoto! {
        didSet {
            if flickrPhoto.isFavourite {
                heartButton.tintColor = UIColor(red: 1, green: 0, blue: 0.517, alpha: 1)
            } else {
                heartButton.tintColor = UIColor.whiteColor()
            }
        }
    }
    
    var heartToggleHandler: ((isFavourite: Bool) -> Void)?
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    @IBAction func heartTapped(sender: AnyObject) {
        flickrPhoto.isFavourite = !flickrPhoto.isFavourite
        
        heartToggleHandler?(isFavourite: flickrPhoto.isFavourite)
    }
    
}

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults!.searchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
        
        if let flickrPhoto = searchResults?.searchResults[indexPath.item] {
            cell.flickrPhoto = flickrPhoto
            
            cell.heartToggleHandler = { isStarred in
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
            flickrPhoto.loadThumbnail { image, error in
                
                if cell.flickrPhoto == flickrPhoto {
                    
                    if flickrPhoto.isFavourite {
                        cell.imageView.image = image
                    } else {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            if let filteredImage = image?.applyTonalFilter() {
                                
                                ImageCache.sharedCache.setImage(filteredImage, forKey: "\(flickrPhoto.photoID)-filtered")
                                dispatch_async(dispatch_get_main_queue(), {
                                    cell.imageView.image = filteredImage
                                })
                                
                            }
                        })
                    }
                }
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PhotoViewController {
            let cell = sender as! SearchResultsCollectionViewCell
            let photoObject = cell.flickrPhoto as FlickrPhoto
            destination.flickrPhoto = photoObject
        }
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = view.bounds.width / 3
        let height = (width / 4) * 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}
















