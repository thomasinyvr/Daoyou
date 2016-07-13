//
//  AppDelegate.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataStackManager.sharedInstance.saveContext()
    }
    
}
