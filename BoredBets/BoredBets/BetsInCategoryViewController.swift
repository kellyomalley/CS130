//
//  BetsInCategoryViewController.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/18/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class BetsInCategoryViewController: UITableViewController {
    
    var selectedCategory: String!
    var selectedBet: Bet!
    var bets: [Bet] = []
    var betsLoaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Categories.getBetsInCategory(selectedCategory)
        {
            self.bets = $0
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bets.count // your number of cell here
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BetListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BetListCell
        let bet = self.bets[indexPath.row]
        let potText = "Pot: " + String(bet.pot)
        
        cell.title?.text = bet.title
        cell.title?.font = cell.title?.font.withSize(20)
        cell.pot?.text = potText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBet = self.bets[indexPath.row]
        if (self.selectedBet.userIsMediator == true) {
            performSegue(withIdentifier: "betListToMediate", sender: self)
        }
        else {
            performSegue(withIdentifier: "betListToBet", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewBetViewController {
            vc.bet = self.selectedBet
        } else if let vc = segue.destination as? MediatorViewController {
            vc.bet = self.selectedBet
        }
    }
    
    func prepareList(){
        Categories.getBetsInCategory(self.selectedCategory){
            self.bets = $0
            self.betsLoaded = true
        }
    }
}
