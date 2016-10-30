//
//  LocalBetMapViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import GoogleMaps

class LocalBetMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, MapDelegate{

    @IBOutlet var mapView: GMSMapView!
    var locationManager: CLLocationManager!
    var camera: GMSCameraPosition!
    //lat and long should be changed with the map's location
    var lat = 37.33233141
    var long = -122.0312186
    var radius = 5.0
    var map: Map!
    var selectedBet: Bet!
    
    override func viewDidLoad() {
        map = Map(mapView: mapView, showMarkers: true)
        map.delegate = self
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.prepareMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        self.map.addMarkers(lat: bet.lat, long: bet.long, bet: bet, markerImage: self.map.betIconWagered)
                    }
                    else if(bet.userIsMediator!){
                        self.map.addMarkers(lat: bet.lat, long: bet.long, bet: bet, markerImage: self.map.betIconMediated)
                    }
                    else{
                         self.map.addMarkers(lat: bet.lat, long: bet.long, bet: bet, markerImage: self.map.betIconNormal)
                    }
                })
            }
        })
    }
    
    func showSelectedBet(bet: Bet){
        self.selectedBet = bet
        performSegue(withIdentifier: "mapToBetView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mapToBetView")
        {
            let nvc = segue.destination as! UINavigationController
            let vbvc = nvc.topViewController as! ViewBetViewController
            vbvc.bet = self.selectedBet
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
