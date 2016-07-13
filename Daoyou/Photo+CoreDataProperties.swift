//
//  Photo+CoreDataProperties.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    @NSManaged var farm: NSNumber
    @NSManaged var id: String
    @NSManaged var isFamily: NSNumber
    @NSManaged var isFriend: NSNumber
    @NSManaged var isPublic: NSNumber
    @NSManaged var owner: String
    @NSManaged var secret: String
    @NSManaged var server: String
    @NSManaged var title: String
    @NSManaged var pin: Pin?
    
}

