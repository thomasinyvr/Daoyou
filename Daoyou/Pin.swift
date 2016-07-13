//
//  Pin.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//


import CoreData
import CoreLocation

class Pin: NSManagedObject {
    
    // MARK: - Initializers
    
    private convenience init() {
        let context = CoreDataStackManager.sharedInstance.managedObjectContext
        let entity = NSEntityDescription.entityForName(self.dynamicType.entityName(), inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    // MARK: - Query
    
    static func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: Pin.entityName())
        do {
            let context = CoreDataStackManager.sharedInstance.managedObjectContext
            return try context.executeFetchRequest(fetchRequest) as? [Pin] ?? []
        } catch {
            return []
        }
    }
    
    // MARK: - Loading
    
    weak var downloadingStateDelegate: DownloadingStateDelegate? = nil
    var downloadingState: DownloadingState = .NotLoaded {
        didSet {
            downloadingStateDelegate?.didChangeState(downloadingState, sender: self)
        }
    }
    
    func getPhotos(handler: ([Photo]?) -> Void) {
        
        switch downloadingState {
        case .NotLoaded:
            downloadPhotos()
        case .IsLoading:
            break
        case .Loaded:
            guard let photos = photos.allObjects as? [Photo] else { return }
            handler(photos)
        }
        
    }
    
    func downloadPhotos() {
        downloadingState = .IsLoading
        
        // Starts download from Flickr
        FlickrGateway.searchForPhotosNearLocation(
            latitude: Double(self.latitude),
            longitude: Double(self.longitude)) { (jsonInner) in
                
                do {
                    let json = try jsonInner()
                    let photos = try FlickrGatewayParser.parsePhotosSearchResult(json, aPin: self)
                    CoreDataStackManager.sharedInstance.saveContext()
                    self.downloadingState = .Loaded
                    for photo in photos {
                        photo.downloadImage(nil)
                    }
                } catch {
                    self.downloadingState = .NotLoaded
                }
                
        }
    }
    
}

    

