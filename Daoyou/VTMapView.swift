//
//  VTMapView.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import MapKit
import CoreLocation

/**
 This is a subclass of MKMapView in order to separate the code for handling
 long presses and additions of annotations. The prefix "VT" stands for
 the project name, Virtual Tourist.
 */
class VTMapView: MKMapView, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    // MARK: - Delegate
    
    var vtDelegate: VTMapViewDelegate?
    
    // MARK: - Properties
    
    var deletionMode = false
    
    // MARK: - Location Manager
    
    let locationManager = CLLocationManager()
    
    // MARK: - Gesture Recognizer
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer {
        let lpgr = UILongPressGestureRecognizer(target: self, action: "longPressOnMapView:")
        lpgr.minimumPressDuration = 0.5 // secs
        lpgr.delegate = self
        return lpgr
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeMap()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeMap()
    }
    
    private func initializeMap() {
        // Adds the long gesture recognizer
        addGestureRecognizer(longPressGestureRecognizer)
        delegate = self
    }
    
    // MARK: - Gesture Recognizer callbacks
    
    func longPressOnMapView(gestureRecognizer: UILongPressGestureRecognizer) {
        
        // Converts the touch into a coordinate
        let coordinate = coordinateFromGestureRecognizer(gestureRecognizer)
        
        switch gestureRecognizer.state {
        case .Began: // Started pressing, so creating a new pin
            vtDelegate?.pinCreationBegan(coordinate)
            
        case .Changed: // User is moving the finger around
            vtDelegate?.pinMovedDuringCreation(coordinate)
            
        case .Ended: // User lifted finger, thus saving the pin placement
            vtDelegate?.pinCreationFinished(coordinate)
            
        default:
            print("\(self.dynamicType), longPressOnMapView, default, does nothing")
        }
    }
    
    private func coordinateFromGestureRecognizer(
        gestureRecognizer: UILongPressGestureRecognizer)
        -> CLLocationCoordinate2D {
            let touchPoint = gestureRecognizer.locationInView(self)
            let touchCoordinate = convertPoint(touchPoint, toCoordinateFromView: self)
            return touchCoordinate
    }
    
    // MARK: - MKMapView overriding
    
    /**
     Adds the given annotation to the map view and centers the map view around that annotation
     
     - parameter annotation: The annotation object to be added and centered around on the map.
     */
    func addAnnotationAndCenter(annotation: MKAnnotation) {
        addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        setRegion(region, animated: true)
        regionThatFits(region)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        
        for aV in views {
            
            // Doesn't apply animation if it is user's location
            if aV.annotation is MKUserLocation {
                return
            }
            
            // Applies drop animation to annotation view
            
            // Defines the final position
            let endFrame = aV.frame
            
            // Moves the view out of the screen
            aV.frame = CGRectOffset(endFrame, 0, -self.frame.size.height)
            
            // Animates the drop
            UIView.animateWithDuration(0.3,
                                       delay: 0.04 * Double(views.indexOf(aV) ?? 0),
                                       options: .CurveLinear,
                                       animations: {
                                        aV.frame = endFrame
                },
                                       completion: { (finished) in
                                        
            })
            
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        if deletionMode {
            mapView.removeAnnotation(annotation)
            vtDelegate?.didRemoveAnnotation(annotation)
        } else {
            vtDelegate?.didSelectAnnotation(annotation)
        }
    }
    
}
