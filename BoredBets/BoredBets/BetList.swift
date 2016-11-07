//
//  BetList.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 11/6/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import CoreLocation


class BetList: UITableView {
    var bets: [Bet]!
    var locationManager: CLLocationManager!
    var lat: Double!
    var long: Double!

    init(frame: CGRect) {
        super.init(coder: NSCoder())!
        self.locationManager.startUpdatingLocation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareList(){
        let user = User(id: User.currentUser())
        user.betsWithinVicinity(latParm: self.lat, longParm: self.long, radMiles: 2, completion: {
            bets in
            for bet in bets {
                self.bets.append(bet)
            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude;
        lat = userLocation.coordinate.latitude;
        prepareList()
        locationManager.stopUpdatingLocation()
    }
}
