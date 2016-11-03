//
//  MakeWagerViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MakeWagerViewController: UIViewController {

    @IBOutlet weak var coinsLeftMessage: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    var bet:Bet?
    var coinsLeft: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        User.usersRef().child(User.currentUser()).observe(.value, with: { snapshot in
            if let coin = snapshot.childSnapshot(forPath: "Coins").value as? Int {
                self.coinsLeft = coin
            }
            else {
                self.coinsLeft = 0
            }
            self.coinsLeftMessage.text = "You Have " + String(self.coinsLeft) + " coins left"
            self.coinsLeftMessage.textAlignment = .center
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func makeWagerDidTouch(_ sender: AnyObject) {
        //retrieve current user:
        let user_id = User.currentUser()
        //make new wager object and attach it to bet
        let betAmount = Int(self.amountTextField.text!)
        if (betAmount! > self.coinsLeft!) {
            BBUtilities.showMessagePrompt("You cannot place a wage with more coins that you have!", controller: self)
        }
        else {
            let newCoinAmount = self.coinsLeft! - betAmount!
            User.usersRef().child(User.currentUser()).child("Coins").setValue(newCoinAmount)
            self.bet?.attachWager(userId: user_id, betAmount: betAmount!, userBet: 1)
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
