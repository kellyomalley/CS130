//
//  MediatingBetsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/28/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MediatingBetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var betsTableView: UITableView!
    var mediatedBets: [Bet] = [Bet()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: for testing
        let user = User(id: User.currentUser())
        user.activeMediatedBets{
            bets in
            print("view controller did load")
            for bet in bets{
                print(bet.title)
                print(bet.id)
            }
            self.mediatedBets = bets
            self.betsTableView.reloadData()
        }
        //TODO: end testing

        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(true, animated:true)
//        //        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(false, animated:true)
//        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE VIEW STUFF
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediatedBets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBet", for: indexPath) as! MediatedBetCellTableViewCell
        let bet = self.mediatedBets[indexPath.row]
        cell.titleLabel.text = bet.title
        cell.potLabel.text = String(bet.pot)
        if (bet.pot < 50){
            cell.coinStackImage.image = UIImage(named: "coin2")
        }
        else if(bet.pot < 400){
            cell.coinStackImage.image = UIImage(named: "SmallStackCoins")
        }
        else{
            cell.coinStackImage.image = UIImage(named: "StackedCoins")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.mediatedBets[indexPath.row])
        performSegue(withIdentifier: "mediatedBetsToMediatorView", sender: self)
    }
    
    //END TABLE VIEW STUFF
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mediatedBetsToMediatorView"){
            let mvc = segue.destination as! MediatorViewController
            let index: Int! = self.betsTableView.indexPathForSelectedRow?.row
            mvc.bet = self.mediatedBets[index]
        }
    }
    

}
