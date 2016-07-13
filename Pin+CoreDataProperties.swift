//
//  Pin+CoreDataProperties.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var photos: Photo?

}
