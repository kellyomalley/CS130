//
//  MediatingBetsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/28/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MediatingBetsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: for testing
        let user = User(id: User.currentUser())
        user.activeMediatedBets{
            bets in
            print("view controller did load")
            for bet in bets{
                print(bet.title)
                print(bet.id)
            }
        }
        //TODO: end testing

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
