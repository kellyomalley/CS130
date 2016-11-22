//
//  ViewProfileViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import Cosmos


class ViewProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var user: User!
    var userId: String!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var coinCountLabel: UILabel!
    
    //collection view
    let reuseIdentifier = "achievementCell"
    //TODO: dynamically load
    var achievements: [String] = []
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    
    //popupview for achievements when clicked
    @IBOutlet weak var achievementPopUpView: UIView!
    @IBOutlet weak var achievmentPopUpImage: UIImageView!
    let popUpTag = 99
    
    
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
            user.userCoinCount(completion: {
                count in
                self.coinCountLabel.text = String(count)
                //achievement setup
                self.user.getAchievements(completion: {
                    achievements in
                    self.achievements = achievements
                    self.achievementCollectionView.reloadData()
                })
            })

        })
        
        starRating.settings.fillMode = .precise
        starRating.settings.updateOnTouch = false
        
        
        //setup for pop up view
        self.achievementPopUpView.tag = self.popUpTag
        self.achievementPopUpView.center.y += self.view.bounds.height
    }
    
    //COLLECTION VIEW FUNCTIONS
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.achievements.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AchievementCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.achievementImageView.image = UIImage(named: self.achievements[indexPath.item])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected the achievement '\(indexPath.item)'!")
        self.achievmentPopUpImage.image = UIImage(named: self.achievements[indexPath.item] + "PopUp")
        self.popUpAppear()
    }
    //END COLLECTION VIEW FUNCTIONS
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view?.tag != self.popUpTag){
                self.popUpDisappear()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    @IBAction func achievementPopUpExitButtonDidTouch(_ sender: Any) {
        self.popUpDisappear()
    }
    
    func popUpAppear(){
        self.achievementPopUpView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.achievementPopUpView.center.y -= self.view.bounds.height
        })
    }
    
    func popUpDisappear(){
        UIView.animate(withDuration: 0.5, animations: {
            self.achievementPopUpView.center.y += self.view.bounds.height
        }, completion: { (finished: Bool) in
            if (finished){
                self.achievementPopUpView.isHidden = true
            }
        })
        

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
