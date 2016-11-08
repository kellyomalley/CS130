//
//  LocalBetMapViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import GoogleMaps

class LocalBetMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, MapDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var listView: UITableView!
    
    
    var locationManager: CLLocationManager!
    var camera: GMSCameraPosition!
    //lat and long should be changed with the map's location
    var lat = 37.33233141
    var long = -122.0312186
    var radius = 5.0
    var map: Map!
    var selectedBet: Bet!
    var showMap: Bool!
    var bets: [Bet] = []
    var betsLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = Map(mapView: mapView, showMarkers: true)
        map.delegate = self
        long = map.long
        lat = map.lat
        showMap = true
       
        self.listView.register(BetListCell.self, forCellReuseIdentifier: "Cell")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        //checks if user doesn't have coin attribute... gives 100 if no coin
        //else if 0, gives user 25 more coins
    }
    
    override func viewDidAppear(_ animated: Bool) {
        map.locationManager.startUpdatingLocation()
        locationManager.startUpdatingLocation()
        betsLoaded = false
        bets = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSelectedBet(bet: Bet){
        self.selectedBet = bet
        performSegue(withIdentifier: "mapToBetView", sender: self)
    }
    
    func createBetAtLocation() {
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mapToBetView")
        {
            let vc = segue.destination as! ViewBetViewController
            vc.bet = self.selectedBet
        }
    }

    @IBAction func toggleView(_ sender: AnyObject) {
        if (showMap == true) {
            self.mapView.isHidden = true
            self.listView.isHidden = false
            self.listView.reloadData()
        }
        else {
            self.mapView.isHidden = false
            self.listView.isHidden = true
        }
        showMap = !showMap
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bets.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BetListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BetListCell
        cell.title?.text = self.bets[indexPath.row].title
        let potText = "Pot: " + String(self.bets[indexPath.row].pot)
        cell.pot?.text = potText
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBet = self.bets[indexPath.row]
        performSegue(withIdentifier: "mapToBetView", sender: self)
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
        self.listView.reloadData()
        self.locationManager.stopUpdatingLocation()
    }
    
    func prepareList(){
        let user = User(id: User.currentUser())
        user.betsWithinVicinity(latParm: self.lat, longParm: self.long, radMiles: 2, completion: {
            bets in
            if (self.betsLoaded == true){
                self.listView.reloadData()
                return
            }
            else {
                for bet in bets {
                    self.bets.append(bet)
                }
                self.betsLoaded = true
            }
        })
    }

}
