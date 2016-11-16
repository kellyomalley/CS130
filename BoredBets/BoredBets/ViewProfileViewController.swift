//
//  ViewProfileViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import Cosmos


class ViewProfileViewController: UIViewController {
    var user: User!
    var userId: String!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userId == nil) {
            self.userId = User.currentUser()
            
        }
        
        User.getUserById(userId, completion: { (user) in
            self.user = user
            self.userNameLabel.text = user.username
            self.starRating.rating = user.rating
            self.starRating.text = String(user.rating)

        })
        
        starRating.settings.fillMode = .precise
        starRating.settings.updateOnTouch = false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
