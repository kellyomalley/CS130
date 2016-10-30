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
    
    
    //User related bet object retrieval... be careful with using cause they're bad ass asynchronous calls
    func activeBets(completion: @escaping ([Bet]) -> ()) {
        //returns a list of bets that the user has wagered money on
        self.activeWagerBetIds{
            betIds in
            self.betsFromIds(betIds: betIds, completion: {
                bets in
                completion(bets)
            })
        }
  
    }
    
    //grab bets for user for which the user is mediating, asynchronous function call
    func activeMediatedBets (completion: @escaping ( [Bet]) -> ()){
        //returns a list of bets that the user is mediating
        //get all ids of bets the user is mediating
        self.activeMediatedBetIds{
            betIds in
            print("activeMediatedBets")
            print(betIds)
            self.betsFromIds(betIds: betIds, completion: {
                bets in
                completion(bets)
            })
            
        }

    }
    
    //grab betIds for user for which the user is mediating, asynchronous function call
    func activeMediatedBetIds(completion: @escaping ([String]) -> ()){
        let userRef = User.usersRef()
        //grab all betIds from the User under child ("BetsMediating")
        userRef.child(self.id).child("BetsMediating").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var betIds: [String] = []
            let value = snapshot.value as? NSDictionary
            for (k,_) in value! {
                betIds.append(k as! String)
            }
            print("activeMediatedBetIds")
            print(betIds)
            completion(betIds)
        })
    }
    
    //gets all betIds given a list of wager id strings, async
    func activeWagerBetIds(completion: @escaping ([String]) -> ()){
        self.activeWagerIds{
            wagerIds in
            let wagerRef = Wager.wagersRef()
            wagerRef.observeSingleEvent(of: .value, with: { (snapshot) in
                var betIds: [String] = []
                for wagerSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    if(wagerIds.contains(wagerSnap.key)){
                        let dict = wagerSnap.value as? NSDictionary
                        var betId: String = "bet_id"
                        for (k,v) in dict!{
                            if (k as? String == "bet_id"){
                                betId = v as! String
                            }
                        }
                        betIds.append(betId)
                    }
                }
                completion(betIds)
            })
            
        }
    }
    
    //grab wagerIds for user for the wagers the user has made, asynchronous function call
    func activeWagerIds(completion: @escaping ([String]) -> ()){
        let userRef = User.usersRef()
        //grab all betIds from the User under child ("BetsMediating")
        userRef.child(self.id).child("Wagers").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var wagerIds: [String] = []
            let value = snapshot.value as? NSDictionary
            for (k,_) in value! {
                wagerIds.append(k as! String)
            }
            print("activeWagerIds")
            print(wagerIds)
            completion(wagerIds)
        })
    }

    
    //grab bets for a list of betId strings, asynchronous function call
    func betsFromIds(betIds: [String], completion: @escaping([Bet]) -> ()){
        Bet.betsRef().observeSingleEvent(of: .value, with: { (snapshot) in
            // get bets with ids
            var bets: [Bet] = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                if(betIds.contains(child.key)){
                    let dict = child.value as? NSDictionary
                    var title: String = "Bet"
                    var pot: Int = 0
                    for (k,v) in dict!{
                        if (k as? String == "title"){
                            title = v as! String
                        }
                        else if (k as? String == "pot"){
                            pot = v as! Int
                        }
                    }
                    let tempBet = Bet(title: title, id: child.key)
                    tempBet.pot = pot
                    bets.append(tempBet)
                }
            }
            print("betsFromIds")
            print(bets)
            completion(bets)
        })
    }
    
    
    
    //to make grabbing the current user universal
    class func currentUser() -> String {
        return (UserDefaults.standard.object(forKey: "user_id") as? String)!
    }
    class func usersRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child("Users")
    }
}
