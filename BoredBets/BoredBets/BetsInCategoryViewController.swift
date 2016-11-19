//
//  BetsInCategoryViewController.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/18/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class BetsInCategoryViewController: UITableViewController {
    
    var selectedCategory: Int!
    var selectedBet: Bet!
    var bets: [Bet] = []
    var betsLoaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupSearchButton()
    }

    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    fileprivate func setupMenuBar() {
        menuBar.setView(view: navigationController!)
        menuBar.setCurrentPos(currentPos: 0)
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    func setupSearchButton() {
        let searchButtonImg = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchButtonImg, style: .plain, target: self, action: #selector(searchFunc))
        
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    func searchFunc() {
        print("Search")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        betsLoaded = false
        self.bets = []
    }
    
    func showSelectedBet(_ bet : Bet){
        self.selectedBet = bet
        if (bet.userIsMediator == true) {
            performSegue(withIdentifier: "betListToMediate", sender: self)
        }
        else {
            performSegue(withIdentifier: "betListToBet", sender: self)
        }
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
        performSegue(withIdentifier: "mapToBetView", sender: self)
    }
    
    func prepareList(){
        Categories.getBetsInCategory(self.selectedCategory){
            self.bets = $0
            self.betsLoaded = true
        }
    }
}
