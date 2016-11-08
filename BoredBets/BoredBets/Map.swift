//
//  Map.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import GoogleMaps

protocol MapDelegate {
    func showSelectedBet(bet: Bet)
    func createBetAtLocation()
}

class Map: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    var lat = 34.068971
    var long = -118.444033
    var radius = 5.0
    var locationManager: CLLocationManager!
    var showMarkers: Bool!
    var delegate: MapDelegate?
    
    let betIconWagered = GMSMarker.markerImage(with: UIColor.green)
    let betIconMediated = GMSMarker.markerImage(with: UIColor.purple)
    let betIconNormal = GMSMarker.markerImage(with: UIColor.blue)

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
    
    func updateCameraAnimation(coord: CLLocationCoordinate2D) {
        let cameraUpdate = GMSCameraUpdate.setTarget(coord)
        mapView.animate(with: cameraUpdate)
    }
    
    func addMarkers(lat: Double, long: Double, bet: Bet, markerImage: UIImage) {
        let marker = BetMarker(bet: bet)
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = bet.title
        let potString = String(bet.pot)
        marker.snippet = "Pot: \(potString)"
        marker.icon = markerImage
        marker.map = self.mapView
    }
    
    func prepareMap(){
        let user = User(id: User.currentUser())
        user.betsWithinVicinity(latParm: self.lat, longParm: self.long, radMiles: self.radius, completion: {
            bets in
            for bet in bets{
                user.userIdsForBetId(betId: bet.id, completion: {
                    userIds in
                    if (userIds.contains(user.id) && !bet.userIsMediator!){
                        bet.userHasWagered = true
                        self.addMarkers(lat: bet.lat, long: bet.long, bet: bet, markerImage: self.betIconWagered)
                    }
                    else if(bet.userIsMediator!){
                        self.addMarkers(lat: bet.lat, long: bet.long, bet: bet, markerImage: self.betIconMediated)
                    }
                    else{
                        self.addMarkers(lat: bet.lat, long: bet.long, bet: bet, markerImage: self.betIconNormal)
                    }
                })
            }
        })
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: BetMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first! as! BetInfoWindow
        infoWindow.isUserInteractionEnabled = false
        infoWindow.title.text = marker.bet.title
        infoWindow.title.textAlignment = .center
        infoWindow.pot.text = String(marker.bet.pot)
        infoWindow.pot.textAlignment = .center
        infoWindow.map = self
        infoWindow.clipsToBounds = true
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOfMarker marker: BetMarker) -> UIView? {
        self.delegate!.showSelectedBet(bet: marker.bet)
        return UIView()
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
        prepareMap()
        locationManager.stopUpdatingLocation()
    }
}
