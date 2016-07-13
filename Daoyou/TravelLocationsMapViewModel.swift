//
//  TravelLocationsMapViewModel.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import Foundation

class TravelLocationsMapViewModel {
    
    // MARK: - Data models
    
    var pinBeingCreated: Pin?
    var pins: [Pin] {
        return Pin.fetchAllPins()
    }
    
    // MARK: - Save
    
    func savePinBeingCreated() {
        guard let newPin = pinBeingCreated else { return }
        pinBeingCreated = nil
        CoreDataStackManager.sharedInstance.saveContext()
        downloadPhotosForNewPin(newPin)
    }
    
    // MARK: - Delete
    
    func deletePin(pin: Pin) {
        CoreDataStackManager.sharedInstance.managedObjectContext.deleteObject(pin)
        CoreDataStackManager.sharedInstance.saveContext()
    }
    
    // MARK: - Photos download
    
    private func downloadPhotosForNewPin(newPin: Pin) {
        newPin.downloadPhotos()
    }
    
}
