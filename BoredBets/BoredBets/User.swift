//
//  User.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase

class User{
    var id:String!
    
    init(id: String){
        self.id = id
    }
    
    func activeBets() -> [Bet] {
        //returns a list of bets that the user has wagered money on
        //TODO: fix placeholder return
        return [Bet()]
    }
    
    func activeMediatedBets() -> [Bet]{
        //returns a list of bets that the user is mediating
        //get all ids of bets the user is mediating
        let betIds = self.activeMediatedBetIds()
        print("HEY")
        print(betIds)
        let bets = self.betsFromIds(betIds: betIds)
        return bets
    }
    
    func activeMediatedBetIds() -> [String]{
        var betIds: [String] = []
        let userRef = User.usersRef()
        //grab all betIds from the User under child ("BetsMediating")
        userRef.child(self.id).child("BetsMediating").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (k,_) in value! {
                betIds.append(k as! String)
                print("iterating")
                print(betIds)
            }
            return betIds
        }){ (error) in
            return []
        }
        print("HEY2")
        print(betIds)
        return betIds
    }
    
    func betsFromIds(betIds: [String]) -> [Bet]{
        //TODO: fix placeholder return
        return [Bet()]
    }
    
    
    
    //to make grabbing the current user universal
    class func currentUser() -> String {
        return (UserDefaults.standard.object(forKey: "user_id") as? String)!
    }
    class func usersRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child("Users")
    }
}
