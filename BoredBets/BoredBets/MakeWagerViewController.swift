//
//  MakeWagerViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MakeWagerViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    var bet:Bet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func makeWagerDidTouch(_ sender: AnyObject) {
        //retrieve current user:
        let user_id = User.currentUser()
        //make new wager object and attach it to bet
        self.bet?.attachWager(userId: user_id, betAmount: Int(self.amountTextField.text!)!, userBet: 1)
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
