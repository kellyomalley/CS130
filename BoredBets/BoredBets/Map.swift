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
    var showMarkers: Bool!
    
    var betIconWagered = GMSMarker.markerImage(with: UIColor.green)
    var betIconMediated = GMSMarker.markerImage(with: UIColor.purple)
    var betIconNormal = GMSMarker.markerImage(with: UIColor.blue)

    init(mapView: GMSMapView!, showMarkers: Bool!) {
        super.init()
        
        self.showMarkers = showMarkers
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
    
    func addMarkers(lat: Double, long: Double, bet: Bet, markerImage: UIImage) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat + 0.001, longitude: long + 0.004)
        marker.title = bet.title
        let potString = String(bet.pot!)
        marker.snippet = "Pot: \(potString)"
        marker.icon = markerImage
        marker.map = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude;
        lat = userLocation.coordinate.latitude;
        updateCamera(lat: lat, long: long)
        //if (self.showMarkers == true) {
            //addMarkers(lat: lat, long: long)
        //}
        locationManager.stopUpdatingLocation()
    }
}
