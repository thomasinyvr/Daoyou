//
//  PhotosAlbumCell.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

class PhotosAlbumCell: UICollectionViewCell {
    
    // MARK: - Reuse ID
    
    static let ReuseIdentifier = "PhotosAlbumCell"
    
    // MARK: - Storyboard outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var grayOverlay: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Selection handling
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            super.selected = newValue
            grayOverlay.hidden = !selected
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        imageView.image = nil
        grayOverlay.hidden = true
    }
    
}
