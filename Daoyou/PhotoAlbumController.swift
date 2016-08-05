//
//  PhotoAlbumController.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PhotoAlbumController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout, PhotoAlbumViewModelDelegate {
    
    // MARK: - Strings
    
    private struct Strings {
        static let NewCollection = NSLocalizedString("New Collection", comment: "")
        static let RemoveSelectedPictures =
            NSLocalizedString("Flag Content/Block User", comment: "")
    }
    
    // MARK: - View model
    
    var viewModel: PhotoAlbumViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLoadingSpinner()
    }
    
    // MARK: - Storyboard outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle(Strings.RemoveSelectedPictures, forState: .Normal)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = true
        }
    }
    @IBOutlet weak var mapView: VTMapView! {
        didSet {
            if let pin = viewModel?.getPin() {
                mapView.addAnnotationAndCenter(pin)
            }
        }
    }
    
    // MARK: - Storyboard actions
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        let selectedIndexPaths = collectionView.indexPathsForSelectedItems() ?? []
        let hasPhotosBeenSelected = selectedIndexPaths.count > 0
        
        if hasPhotosBeenSelected {
            viewModel?.deletePhotosAtIndexPaths(selectedIndexPaths)
            collectionView.deleteItemsAtIndexPaths(selectedIndexPaths)
        } else {
            viewModel?.refreshPhotosCollection()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView( collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel?.getPhotosCount() ?? 0
    }
    
    func collectionView( collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                PhotosAlbumCell.ReuseIdentifier,
                forIndexPath: indexPath)
            
            if let photoCell = cell as? PhotosAlbumCell {
                viewModel?.getImageForIndexPath(indexPath) { image in
                    photoCell.activityIndicator.stopAnimating()
                    photoCell.imageView.image = image
                }
            }
            
            return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView( collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView.indexPathsForSelectedItems()?.count > 0 {
            button.setTitle(Strings.RemoveSelectedPictures, forState: .Normal)
        }
        
    }
    
    func collectionView( collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView.indexPathsForSelectedItems()?.count == 0 {
            button.setTitle(Strings.RemoveSelectedPictures, forState: .Normal)
        }
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let thirdWidth = collectionView.frame.size.width / 3
            return CGSize(width: thirdWidth, height: thirdWidth)
    }
    
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int)
        -> UIEdgeInsets {
            return UIEdgeInsetsZero
    }
    
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int)
        -> CGFloat {
            return 0
    }
    
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int)
        -> CGFloat {
            return 0
    }
    
    // MARK: - PhotoAlbumViewModelDelegate
    
    func pinWillDownloadMetaDataForPhotos() {
        updateLoadingSpinner()
        collectionView.reloadData()
    }
    
    func pinDidDownloadMetaDataForPhotos() {
        updateLoadingSpinner()
        collectionView.reloadData()
    }
    
    func photoDidDownloadImageAtIndexPath(indexPath: NSIndexPath) {
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    // MARK: - Loading
    
    private func updateLoadingSpinner() {
        let shouldHideLoadingSpinner = !(viewModel?.isDownloadingPhotosMetaData ?? false)
        if shouldHideLoadingSpinner {
            updateInfoLabel()
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    private func updateInfoLabel() {
        let isPinDownloading = viewModel?.isDownloadingPhotosMetaData ?? false
        let pinHasZeroPhotos = viewModel?.getPhotosCount() == 0
        let shouldShowInfoLabel = !isPinDownloading && pinHasZeroPhotos
        infoLabel.hidden = !shouldShowInfoLabel
    }
    
}
