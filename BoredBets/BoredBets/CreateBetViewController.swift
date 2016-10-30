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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createBetToViewBet") {
            let nav = segue.destination as! UINavigationController
            let vbvc = nav.topViewController as! ViewBetViewController
            vbvc.bet = self.bet
            
        }
    }
    

}
