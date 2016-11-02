//
//  CreateBetViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateBetViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    let bet:Bet = Bet()
    var betTitle: String?
    var map :Map!

    override func viewDidLoad() {
        super.viewDidLoad()
        map = Map(mapView: mapView, showMarkers: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createBetDidTouch(_ sender: UIButton) {
        self.bet.title = self.betTitle!
        self.bet.lat = self.map.lat
        self.bet.long = self.map.long
        self.bet.saveNewBetToFB()
        
        let baseViewController = self.navigationController?.viewControllers[0]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediatorView") as! MediatorViewController
        controller.bet = self.bet
        self.navigationController?.setViewControllers([baseViewController!, controller], animated: true)
    }
}
