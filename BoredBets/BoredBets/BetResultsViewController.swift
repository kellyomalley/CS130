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
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    
    
    //force unwrapped b/c this VC should never be initialized unless there is a bet object being passed in
    var bet: Bet!
    var comments: [(String, String, Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //grab all wagers
        self.finalOutcomeLabel.text = "\(bet.finalOutcome!)"
        self.potLabel.text = "\(self.bet.pot)"
        self.navigationItem.title = self.bet.title
        self.reloadTable()
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
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row].0
        cell.detailTextLabel?.text = comments[indexPath.row].1
        return cell
    }
    
    func reloadTable()
    {
        self.bet.getComments(){(comments: [(String, String, Double)]) in
            self.comments = comments
            DispatchQueue.main.async{
                self.commentTableView.reloadData()
            }
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
