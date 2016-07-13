//
//  Photo.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {
    
    // MARK: - Constants
    
    private struct JsonKeys {
        static let Id = "id"
        static let IsFamily = "isfamily"
        static let IsFriend = "isfriend"
        static let IsPublic = "ispublic"
        static let Owner = "owner"
        static let Secret = "secret"
        static let Server = "server"
        static let Title = "title"
        static let Farm = "farm"
    }
    
    // MARK: - Initializers
    
    private convenience init() {
        let context = CoreDataStackManager.sharedInstance.managedObjectContext
        let entity = NSEntityDescription.entityForName(self.dynamicType.entityName(), inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(dict: [String: AnyObject], aPin: Pin) {
        self.init()
        id = dict[JsonKeys.Id] as? String ?? ""
        isFamily = dict[JsonKeys.IsFamily] as? Int ?? 0
        isFriend = dict[JsonKeys.IsFriend] as? Int ?? 0
        isPublic = dict[JsonKeys.IsPublic] as? Int ?? 0
        owner = dict[JsonKeys.Owner] as? String ?? ""
        secret = dict[JsonKeys.Secret] as? String ?? ""
        server = dict[JsonKeys.Server] as? String ?? ""
        title = dict[JsonKeys.Title] as? String ?? ""
        farm = dict[JsonKeys.Farm] as? Int ?? 0
        pin = aPin
    }
    
    // MARK: - Url
    
    var url: NSURL {
        let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_z.jpg"
        return NSURL(string: url)!
    }
    
    // MARK: - Printable
    
    override var description: String {
        var desc = "id: \(id), isFamily: \(isFamily), isFriend: \(isFriend), isPublic: \(isPublic)"
        desc += ", owner: \(owner), secret: \(secret), server: \(server), farm: \(farm)"
        desc += ", title: \(title) \n"
        return desc
    }
    
    // MARK: - Loading
    
    weak var downloadingStateDelegate: DownloadingStateDelegate? = nil
    var downloadingState: DownloadingState = .NotLoaded {
        didSet {
            downloadingStateDelegate?.didChangeState(downloadingState, sender: self)
        }
    }
    
    func getImage(handler: (UIImage?) -> Void) {
        
        switch downloadingState {
        case .NotLoaded:
            downloadImage(handler)
        case .IsLoading:
            break
        case .Loaded:
            return FileManager.readImageFromDocumentsDirectory(id, handler: handler)
        }
        
    }
    
    func downloadImage(handler: ((UIImage?) -> Void)?) {
        downloadingState = .IsLoading
        ImageHandler.downloadJpgImageToLocalFileSystemFromUrl(url, withFileName: id, successHandler: { [weak self] (image) in handler?(image)
                self?.downloadingState = .Loaded
            },
                errorHandler: { [weak self] in
                self?.downloadingState = .NotLoaded
            })
    }
    
    // MARK: - Deletion
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        FileManager.deleteImageInDocumentsDirectory(id)
    }
    
}
