//
//  FileManager.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

/**
 *  A utlity class to help interacting with the local file system on the iOS device.
 */
struct FileManager {
    
    // MARK: - Constants
    
    private struct FileConstants {
        static let DefaultImageExtension = "jpg"
    }
    
    // MARK: - Property heleprs
    
    /// An easy reference to the default NSFileManager
    private static var manager: NSFileManager {
        return NSFileManager.defaultManager()
    }
    
    /// An easy reference to the Documents Directory of the app
    private static var documentsDirectory: NSURL {
        return manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    }
    
    /**
     An easy reference to the Images folder created in the Documents Directory to
     store all of the images downloaded from Flickr.
     */
    private static var imageDirectory: NSURL {
        return documentsDirectory
        // TODO: Creates an images directory
    }
    
    // MARK: - Public methods
    
    /**
     Saves the given UIImage in the local file system as the given file name. If no extension
     type is provided, then the default of `jpg` will be appended to the file name.
     
     - parameter image:         The image to be saved locally.
     - parameter fileName:      The file name which should be used when saving the image.
     - parameter fileExtension: The file extension which should be used to save the image. If this
     value is not given, then it will default to `jpg`.
     */
    static func saveImageToDocumentsDirectory(
        image: UIImage,
        withFileName fileName: String,
                     andFileExtension fileExtension: String = FileConstants.DefaultImageExtension) {
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.99) else { return }
        var path = imageDirectory.URLByAppendingPathComponent(fileName)
        path = path.URLByAppendingPathExtension(fileExtension)
        imageData.writeToURL(path, atomically: true)
    }
    
    static func readImageFromDocumentsDirectory(
        fileName: String,
        fileExtension: String = FileConstants.DefaultImageExtension,
        handler: (UIImage?) -> Void) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            guard fileName.characters.count > 0 else { handler(nil); return }
            var filePath = imageDirectory.URLByAppendingPathComponent(fileName)
            filePath = filePath.URLByAppendingPathExtension(fileExtension)
            let imageData = NSData(contentsOfURL: filePath)
            let image = UIImage(data: imageData ?? NSData())
            dispatch_async(dispatch_get_main_queue()) {
                handler(image)
            }
        }
    }
    
    static func deleteImageInDocumentsDirectory(
        fileName: String,
        fileExtension: String = FileConstants.DefaultImageExtension) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            guard fileName.characters.count > 0 else { return }
            var filePath = imageDirectory.URLByAppendingPathComponent(fileName)
            filePath = filePath.URLByAppendingPathExtension(fileExtension)
            do {
                try manager.removeItemAtURL(filePath)
            } catch {
                // Does nothing
            }
            
        }
        
    }
    
}
