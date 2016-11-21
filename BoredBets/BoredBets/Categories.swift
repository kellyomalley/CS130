//
//  Categories.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/18/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase

class Categories{
    
    class func getCategories(_ completion: @escaping ([String]) -> ()){
        self.categoriesRef().observeSingleEvent(of: .value, with: { (snapshot) in
            var categoriesOrdered : [String] = []
            for categorySnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                categoriesOrdered.append(categorySnap.key)
            }
            categoriesOrdered.sort(by: >)
            completion(categoriesOrdered)
        })
    }
    
    class func getBetsInCategory(_ categoryName : String, completion: @escaping ([Bet]) -> ()){
        self.categoriesRef().child(categoryName).observeSingleEvent(of: .value, with: { (snapshot) in
            var betIds: [String] = []
            let value = snapshot.value as? NSDictionary
            if (value != nil){
                for (_,v) in value! {
                    betIds.append(v as! String)
                }
            }
            User.thisUser?.betsFromIds(betIds: betIds, completion: {
                bets in
                var activeBets: [Bet] = []
                for bet in bets{
                    if bet.state != BetState.Settled{
                        activeBets.append(bet)
                    }
                }
                completion(activeBets)
            })
        })
    }
    
    class func categoriesRef() -> FIRDatabaseReference{
        return FIRDatabase.database().reference().child("Categories")
    }
}
