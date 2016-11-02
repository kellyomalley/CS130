//
//  ActiveBetsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/28/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class ActiveBetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activeBetsTableView: UITableView!
    var activeBets: [Bet] = [Bet()]

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User(id: User.currentUser())
        user.activeBets{
            bets in
            print("active bets controller did load")
            for bet in bets{
                print(bet.title)
                print(bet.id)
            }
            self.activeBets = bets
            self.activeBetsTableView.reloadData()
        }


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
        return self.activeBets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeBetCell", for: indexPath)
        let bet = self.activeBets[indexPath.row]
        cell.textLabel?.text = bet.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.activeBets[indexPath.row])
        performSegue(withIdentifier: "activeBetsToBetView", sender: self)
    }
    
    //END TABLE VIEW STUFF

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vbvc = segue.destination as! ViewBetViewController
        let indexSelected = self.activeBetsTableView.indexPathForSelectedRow?.row
        vbvc.bet = self.activeBets[indexSelected!]
    }
 

}
