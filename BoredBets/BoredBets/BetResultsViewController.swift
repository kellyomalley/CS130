//
//  BetResultsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 11/9/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class BetResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var finalOutcomeLabel: UILabel!
    @IBOutlet weak var mediatorPayoutLabel: UILabel!
    @IBOutlet weak var betTitleLabel: UILabel!
    @IBOutlet weak var wagerTableView: UITableView!
    
    //force unwrapped b/c this VC should never be initialized unless there is a bet object being passed in
    var bet: Bet!
    var wagers: [Wager] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //grab all wagers
        self.bet.wagerIds(completion: {
            wagerIds in
            self.bet.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
                wagers in
                self.wagers = wagers
                //sort wagers by bet amount
                self.wagers.sort{ $0.betAmount > $1.betAmount }
                //reload table
                self.wagerTableView.reloadData()
            })
        })
        self.finalOutcomeLabel.text = "Final Outcome: \(bet.finalOutcome!)"
        self.mediatorPayoutLabel.text = "Mediator Payout: \(self.bet.payout!)"
        self.betTitleLabel.text = self.bet.title
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE VIEW STUFF
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wagers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wagerCell", for: indexPath)
        let wager = self.wagers[indexPath.row]
        cell.textLabel?.text = "Bet Amount: \(wager.betAmount)"
        return cell
    }
    
    //currently no select functionality for rows
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.activeBets[indexPath.row])
        performSegue(withIdentifier: "activeBetsToBetView", sender: self)
    }*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
