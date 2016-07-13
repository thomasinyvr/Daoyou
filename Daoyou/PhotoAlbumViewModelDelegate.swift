//
//  PhotoAlbumViewModelDelegate.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

protocol PhotoAlbumViewModelDelegate: class {
    func pinWillDownloadMetaDataForPhotos()
    func pinDidDownloadMetaDataForPhotos()
    func photoDidDownloadImageAtIndexPath(indexPath: NSIndexPath)
}
