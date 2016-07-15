//
//  TravelLocationsMapControler.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class TravelLocationsMapController: UIViewController, MKMapViewDelegate, VTMapViewDelegate, SegueHandlerType, CLLocationManagerDelegate {
    
    // MARK: - Segue identifiers
    
    enum SegueIdentifier: String {
        case ShowPhotoAlbumForPin
    }
    
    // MARK: - locationManagerInitialize
    
    let locationManager = CLLocationManager()
   
    // MARK: - View model
    
    private var viewModel = TravelLocationsMapViewModel()
    
    // MARK: - Storyboard outlets
    
    @IBOutlet weak var tapPinForPhotosLabel: UILabel!
    
    @IBOutlet weak var mapView: VTMapView! {
        didSet {
            mapView.vtDelegate = self
            mapView.addAnnotations(viewModel.pins)
        }
    }
    
    // MARK: - Storyboard auto layout constraints
    
    @IBOutlet weak var deletionLabelHeight: NSLayoutConstraint!
    
    // MARK: - Storyboard actions
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        
        mapView.deletionMode = !mapView.deletionMode
        // Animates the showing/hiding of deletion labels
        view.layoutIfNeeded()
        self.deletionLabelHeight.constant = (self.mapView.deletionMode) ? 70 : 0
        UIView.animateWithDuration(0.25) {
            self.view.layoutIfNeeded()
            self.tapPinForPhotosLabel.hidden = true
            
        }
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.rightBarButtonItem = editButtonItem()

        
        // MARK: - locationManager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - VTMapViewDelegate
    
    func pinCreationBegan(coordinate: CLLocationCoordinate2D) {
        let pin = Pin(coordinate: coordinate)
        mapView.addAnnotation(pin)
        viewModel.pinBeingCreated = pin
    }
    
    func pinMovedDuringCreation(newCoordinate: CLLocationCoordinate2D) {
        viewModel.pinBeingCreated?.setCoordinate(newCoordinate)
    }
    
    func pinCreationFinished(finalCoordinate: CLLocationCoordinate2D) {
        viewModel.savePinBeingCreated()
    }
    
    func didSelectAnnotation(annotation: MKAnnotation) {
        guard let pin = annotation as? Pin else { return }
        performSegueWithIdentifier(.ShowPhotoAlbumForPin, sender: pin)
    }
    
    func didRemoveAnnotation(annotation: MKAnnotation) {
        guard let pin = annotation as? Pin else { return }
        viewModel.deletePin(pin)
    }
    
    // MARK: - Segue logic
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segueIdentifierForSegue(segue) {
        case .ShowPhotoAlbumForPin:
            
            guard
                let
                pin = sender as? Pin,
                destinationVC = segue.destinationViewController as? PhotoAlbumController else {
                    return
            }
            destinationVC.viewModel = PhotoAlbumViewModel(pin: pin)
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedWhenInUse)
        
    }
    
}
