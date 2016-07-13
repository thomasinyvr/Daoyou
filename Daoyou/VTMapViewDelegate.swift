//
//  VTMapViewDelegate.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import MapKit

protocol VTMapViewDelegate {
    func pinCreationBegan(coordinate: CLLocationCoordinate2D)
    func pinMovedDuringCreation(newCoordinate: CLLocationCoordinate2D)
    func pinCreationFinished(finalCoordinate: CLLocationCoordinate2D)
    func didSelectAnnotation(annotation: MKAnnotation)
    func didRemoveAnnotation(annotation: MKAnnotation)
}
