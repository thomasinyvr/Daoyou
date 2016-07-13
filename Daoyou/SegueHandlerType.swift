//
//  SegueHandlerType.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

/**
 *  This protocol has been defined as described in the blog post:
 *  "Protocol-Oriented Segue Identifiers in Swift" written by Natasha Murashev
 *  https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
 */
protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}
