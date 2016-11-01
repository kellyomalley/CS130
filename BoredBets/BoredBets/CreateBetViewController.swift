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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createBetToMediateBet") {
            let mvc = segue.destination as! MediatorViewController
            mvc.bet = self.bet
        }
    }
    

}
