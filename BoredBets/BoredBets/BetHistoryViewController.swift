//
//  BetHistoryViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 11/9/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class BetHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mediatedBets: [Bet] = []
    var wagers: [Wager] = []
    var bet: Bet?
    
    @IBOutlet weak var betHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User(id: User.currentUser())
        user.wagerIds(completion: {
            wagerIds in
            user.expiredWagers(forIds: wagerIds, wagers: [], completion: {
                wagers in
                self.wagers = wagers
                self.betHistoryTableView.reloadData()
            })
        })
        user.expiredMediatedBets(completion: {
            bets in
            self.mediatedBets = bets
            self.betHistoryTableView.reloadData()
        })
        //grab wagers related to user with payout...
        //sort according to bet settled timestamp
        //reload table
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE VIEW STUFF
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return self.wagers.count
        }
        else{
            return self.mediatedBets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "wagerCell", for: indexPath) as! BetHistoryTableViewCell
            let wager = self.wagers[indexPath.row]
            let diff = wager.payout! - wager.betAmount
            if (diff >= 0){
                cell.coinDiffLabel.text = "+\(diff)"
            }
            else{
                cell.coinDiffLabel.text = "\(diff)"
                cell.coinDiffLabel.textColor = UIColor.red
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediatedBetsCell", for: indexPath) as! BetHistoryTableViewCell
            let bet = self.mediatedBets[indexPath.row]
            cell.coinDiffLabel.text =  "+\(bet.payout!)"
            return cell
        }
    }
    
    //currently no select functionality for rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            let wager = self.wagers[indexPath.row]
            wager.getBet(completion: {
                bet in
                self.bet = bet
                self.performSegue(withIdentifier: "betHistoryToBetResults", sender: self)
            })
        }
        else{
            self.bet = self.mediatedBets[indexPath.row]
            self.performSegue(withIdentifier: "betHistoryToBetResults", sender: self)
        }
     
     }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "betHistoryToBetResults"){
           let nvc = segue.destination as! BetResultsViewController
           nvc.bet = self.bet!
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
