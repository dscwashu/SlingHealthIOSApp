//
//  PharmacyMapsViewController.swift
//  SlingHealth_v1
//
//  Created by Priyanshu on 05/03/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import MapKit

class PharmacyMapsViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Variables
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    //MARK: - UIViewController life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapView()
    }
    
    //MARK: - Setup Methods
    func setUpMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        
        //TODO: - show only certain things on the map
        
        showCurrentLocation()
    }
    
    //MARK: - Show user location on map
    func showCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
