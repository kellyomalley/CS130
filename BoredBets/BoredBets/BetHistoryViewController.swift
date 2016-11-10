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
            let cell = tableView.dequeueReusableCell(withIdentifier: "wagerCell", for: indexPath)
            let wager = self.wagers[indexPath.row]
            cell.textLabel?.text = "Bet Amount: \(wager.betAmount)... p: \(wager.payout)"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediatedBetsCell", for: indexPath)
            let bet = self.mediatedBets[indexPath.row]
            cell.textLabel?.text = "Your Payout: \(bet.payout)"
            return cell
        }
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
