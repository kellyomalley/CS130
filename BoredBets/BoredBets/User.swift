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
    func activeBets() -> [Bet] {
        //returns a list of bets that the user has wagered money on
        //TODO: fix placeholder return
        return [Bet()]
    }
    
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
                            pot = Int(v as! String)!
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
