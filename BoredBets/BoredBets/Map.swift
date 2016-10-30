//
//  Map.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import GoogleMaps


class Map: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    var lat = 34.068971
    var long = -118.444033
    var locationManager: CLLocationManager!

    
    init(mapView: GMSMapView!) {
        super.init()
        
        self.mapView = mapView
        self.mapView.delegate = self;
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func updateCamera(lat: Double, long: Double) {
        camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        mapView.camera = camera
    }
    
    func addMarkers(lat: Double, long: Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat + 0.001, longitude: long + 0.004)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude;
        lat = userLocation.coordinate.latitude;
        updateCamera(lat: lat, long: long)
        addMarkers(lat: lat, long: long)
        locationManager.stopUpdatingLocation()
    }
}
