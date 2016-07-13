//
//  SegueHandlerType+Extension.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import Foundation
import UIKit

/**
 *  This protocol extension has been defined as described in the blog post:
 *  "Protocol-Oriented Segue Identifiers in Swift" written by Natasha Murashev
 *  https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
 */
extension SegueHandlerType where Self: UIViewController,SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        
        guard
            let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Invalid segue identifier \(segue.identifier).") }
        
        return segueIdentifier
    }
}
