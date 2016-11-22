//
//  MediatorViewController.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/1/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MediatorViewController: UIViewController {
    var bet:Bet!
    
    @IBOutlet weak var betTitleLabel: UILabel!
    
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var betTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Bet.betsRef().child(bet.id).observe(.value, with: { snapshot in
            let title = snapshot.childSnapshot(forPath: "title").value as! String
            let pot = snapshot.childSnapshot(forPath: "pot").value as! Int
            
            //updating fields on view
            self.betTitleLabel.text = title
            self.potLabel.text = String(pot)
            
            //updating bet member variables
            self.bet.title = title
        })
        self.betTypeLabel.text = self.bet?.type
        self.betTitleLabel.text = self.bet?.title
        self.hideKeyboardWhenTapped()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSettleBet"){
            let vc = segue.destination as! SettleBetViewController
            vc.bet = self.bet
        }
        // Pass the selected object to the new view controller.
    }
    

}
