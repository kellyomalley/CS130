//
//  CreateBetMap.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 11/3/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import GoogleMaps

class CreateBetMap: Map {
    var marker: GMSMarker!
    
    override func mapView(_ mapView: GMSMapView, markerInfoWindow marker: BetMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("SetLocationInfoWindow", owner: self, options: nil)?.first! as! UIView
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.marker = GMSMarker()
        self.marker.position = coordinate
        self.marker.title = "Your Location"
        self.marker.map = self.mapView
        self.mapView.delegate = self
        self.mapView.selectedMarker = self.marker
        self.updateCameraAnimation(coord: coordinate)
    }
    
    override func mapView(_ mapView: GMSMapView, didTapInfoWindowOfMarker marker: BetMarker) -> UIView? {
        self.delegate!.createBetAtLocation()
        return UIView()
    }
    
    func locationMarker(lat: Double, long: Double) {
        self.marker = GMSMarker()
        self.marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.marker.title = "Your Location"
        self.marker.map = self.mapView
        self.mapView.selectedMarker = self.marker
    }
    
    override func prepareMap() {
        locationMarker(lat: self.lat, long: self.long)
    }
}
