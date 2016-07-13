//
//  PhotoAlbumViewModel.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

class PhotoAlbumViewModel: NSObject, DownloadingStateDelegate {
    
    // MARK: - Delegate
    
    weak var delegate: PhotoAlbumViewModelDelegate?
    
    // MARK: - Data models
    
    private var photos: [Photo] = []
    private var pin: Pin?
    
    // MARK: - Initializers
    
    private override init() { }
    
    init(pin: Pin) {
        super.init()
        self.pin = pin
        pin.downloadingStateDelegate = self
        setPhotosModelFromPin(pin)
    }
    
    // MARK: - Setters
    
    private func setPhotosModelFromPin(aPin: Pin) {
        photos = aPin.photos.allObjects as? [Photo] ?? []
        for photo in photos {
            photo.downloadingStateDelegate = self
        }
    }
    
    // MARK: - Getters
    
    var isDownloadingPhotosMetaData: Bool {
        return pin?.downloadingState == .IsLoading
    }
    
    func getPin() -> Pin? {
        return pin
    }
    
    func getPhotosCount() -> Int {
        return photos.count ?? 0
    }
    
    func getImageForIndexPath(indexPath: NSIndexPath, handler: (UIImage?) -> Void) {
        photos[indexPath.item].getImage(handler)
    }
    
    // MARK: - Logic
    
    func deletePhotosAtIndexPaths(selectedPhotosIndexPaths: [NSIndexPath]) {
        
        let selectedPhotos = selectedPhotosIndexPaths.map { return photos[$0.item] }
        let selectedPhotosSet = Set<Photo>(selectedPhotos)
        let photosSet = Set<Photo>(photos)
        photos = Array(photosSet.subtract(selectedPhotosSet))
        deletePhotos(selectedPhotos)
    }
    
    func refreshPhotosCollection() {
        deletePhotos(photos)
        pin?.downloadPhotos()
    }
    
    private func deletePhotos(photosToDelete: [Photo]) {
        for photo in photosToDelete {
            CoreDataStackManager.sharedInstance.managedObjectContext.deleteObject(photo)
        }
        CoreDataStackManager.sharedInstance.saveContext()
    }
    
    // MARK: - PhotoDownloadStateDelegate
    
    func didChangeState(newState: DownloadingState, sender: AnyObject) {
        
        if sender is Pin && newState == .IsLoading {
            guard let pin = sender as? Pin else { return }
            setPhotosModelFromPin(pin)
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.pinWillDownloadMetaDataForPhotos()
            }
        }
        
        if sender is Pin && newState == .Loaded {
            guard let pin = sender as? Pin else { return }
            setPhotosModelFromPin(pin)
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.pinDidDownloadMetaDataForPhotos()
            }
        }
        
        if sender is Photo && newState == .Loaded {
            guard
                let photo = sender as? Photo,
                let index = photos.indexOf(photo) else {
                    return
            }
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.photoDidDownloadImageAtIndexPath(indexPath)
            }
        }
    }
    
}
