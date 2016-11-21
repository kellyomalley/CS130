//
//  CreateBetViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateBetViewController: UIViewController, MapDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    var bet: Bet!
    var map: CreateBetMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = "Back"
        map = CreateBetMap(mapView: mapView, showMarkers: false)
        map.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBetAtLocation() {
        self.bet.lat = self.map.marker.position.latitude
        self.bet.long = self.map.marker.position.longitude
        self.bet.saveNewBetToFB()
        
        let baseViewController = self.navigationController?.viewControllers[0]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediatorView") as! MediatorViewController
        controller.bet = self.bet
        self.navigationController?.setViewControllers([baseViewController!, controller], animated: true)
    }
    
    func showSelectedBet(bet: Bet) {
        return
    }
    
}
