//
//  ImageHandler.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

import UIKit

struct ImageHandler {
    
    // MARK: - Download
    
    static func downloadJpgImageToLocalFileSystemFromUrl(
        url: NSURL,
        withFileName fileName: String,
                     successHandler: (UIImage?) -> Void,
                     errorHandler: () -> Void) {
        
        NetworkManager.sharedInstance.getImageForUrl(url) { (inner) -> Void in
            do {
                let image = try inner()
                FileManager.saveImageToDocumentsDirectory(image, withFileName: fileName)
                successHandler(image)
            } catch {
                errorHandler()
            }
        }
        
    }
    
}