//
//  SpecificCategoryBetViewController.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 11/20/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class SpecificCategoryBetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var betsInCategorytableView: UITableView!

    var bets: [Bet]!
    var category: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bets = []
        self.betsInCategorytableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryBets")
        let user = User(id: User.currentUser())
        user.betsinCategory(selectedCategory: category, completion: {
            bets in
            for bet in bets{
                self.bets.append(bet)
            }
            self.betsInCategorytableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.bets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell:UITableViewCell = self.betsInCategorytableView.dequeueReusableCell(withIdentifier: "categoryBets")! as UITableViewCell
        cell.textLabel?.text = bets[indexPath.row].title        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
