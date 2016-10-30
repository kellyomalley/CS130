//
//  LocalBetMapViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import GoogleMaps

class LocalBetMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet var mapView: GMSMapView!
    var locationManager: CLLocationManager!
    var camera: GMSCameraPosition!
    var lat = 34.068971
    var long = -118.444033
    var map: Map!
    
    override func viewDidLoad() {
        
        map = Map(mapView: mapView)
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
