//
//  User.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class User{
    var id:String!
    var username:String!
    
    init(id: String){
        self.id = id
    }
    
    func setUserName(name : String){
        self.username = name
        User.usersRef().child(self.id).setValue(["username": name])
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
            if (value != nil){
                for (k,_) in value! {
                    betIds.append(k as! String)
                }
            }
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
            if (value != nil){
                for (k,_) in value! {
                    wagerIds.append(k as! String)
                }
            }
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
                    var pot = 0
                    var type = ""
                    var outcome1 = ""
                    var outcome2 = ""
                    var userIsMediator = false
                    for (k,v) in dict!{
                        switch k as! String{
                            case "title":
                                title = v as! String
                            case "pot":
                                pot = v as! Int
                            case "type":
                                type = v as! String
                            case "outcome1":
                                outcome1 = v as! String
                            case "outcome2":
                                outcome2 = v as! String
                            case "mediator_id":
                                if (v as! String == self.id){
                                    userIsMediator = true
                                }
                            default:
                                print("Some other key")
                        }
                    }
                    let betFactory = BetFactory.sharedFactory
                    let tempBet: Bet! = betFactory.makeBet(type: type)
                    if (tempBet != nil){
                        tempBet.title = title
                        tempBet.id = child.key
                        tempBet.pot = pot
                        tempBet.outcome1 = outcome1
                        tempBet.outcome2 = outcome2
                        tempBet.userIsMediator = userIsMediator
                        bets.append(tempBet)
                    }
                }
            }
            completion(bets)
        })
    }
    
    //FOR MAPS API
    //returns list of bets within the radius provided (with regards to the user's location)
    //also attaches appropriate relationship to the user for color coordination of pins
    func betsWithinVicinity(latParm: Double, longParm: Double, radMiles: Double, completion: @escaping([Bet]) -> ()){
        let betsRef = Bet.betsRef()
        betsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get bets with ids
            var bets: [Bet] = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let dict = child.value as? NSDictionary
                var title: String = "Bet"
                var pot: Int = 0
                var lat: Double = 0
                var long: Double = 0
                var userIsMediator: Bool = false
                var type: String = ""
                var outcome1: String = ""
                var outcome2: String = ""
                for (k,v) in dict!{
                    switch k as! String{
                        case "title":
                            title = v as! String
                        case "pot":
                            pot = v as! Int
                        case "lat":
                            lat = v as! Double
                        case "long":
                            long = v as! Double
                        case "mediator_id":
                            if (v as! String == self.id){
                                userIsMediator = true
                            }
                        case "type":
                            type = v as! String
                        case "outcome1":
                            outcome1 = v as! String
                        case "outcome2":
                            outcome2 = v as! String
                        default:
                            print("Some other key")
                    }
                }
                //check if the longitude and latitude are within the defined parms
                if (self.withinVicinity(latParm: latParm, longParm: longParm, lat: lat, long: long, radMiles: radMiles)){
                    let betFactory = BetFactory.sharedFactory
                    let tempBet: Bet! = betFactory.makeBet(type: type)
                    if (tempBet != nil){
                        tempBet.id = child.key
                        tempBet.title = title
                        tempBet.pot = pot
                        tempBet.lat = lat
                        tempBet.long = long
                        tempBet.userIsMediator = userIsMediator
                        tempBet.outcome1 = outcome1
                        tempBet.outcome2 = outcome2
                        bets.append(tempBet)
                    }
                }
            }
            completion(bets)
        })
        
    }
    
    //returns true if the two coordinates given are within the miles radius parm
    //false otherwise
    func withinVicinity(latParm: Double, longParm: Double, lat: Double, long: Double, radMiles: Double) -> Bool {
        
        let coordinate1 = CLLocation(latitude: latParm, longitude: longParm)
        let coordinate2 = CLLocation(latitude: lat, longitude: long)
        let dMeters = coordinate1.distance(from: coordinate2)
        let rMeters = 1609 * radMiles
        if (dMeters > rMeters){
            return false
        }
        else {
            return true
    
        }
    }
    
    //gets userIds for users that have placed wagers on a bet
    func userIdsForBetId(betId: String, completion: @escaping([String]) -> ()){
        let wagersRef = Wager.wagersRef()
        wagersRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var userIds: [String] = []
            for wagerSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let dict = wagerSnap.value as? NSDictionary
                var userId = "user_id"
                var betIdMatch: Bool = false
                for (k,v) in dict!{
                    if (k as? String == "user_id"){
                        userId = v as! String
                    }
                    else if (k as? String == "bet_id" && v as? String == betId){
                        betIdMatch = true
                    }
                }
                if (betIdMatch){
                    userIds.append(userId)
                }
                
            }
            completion(userIds)
        })
    }
    
    //returns user's coin count
    //if no coin attribute on user, returns -1
    func userCoinCount(completion: @escaping (Int) -> ()){
        User.usersRef().child(self.id).child("coins").observe(.value, with: { snapshot in
            if let coin = snapshot.childSnapshot(forPath: "coins").value as? Int {
                completion(coin)
            }
            else {
                completion(-1)
            }

        })
    }
    
    //to make grabbing the current user universal
    class func currentUser() -> String {
        return (UserDefaults.standard.object(forKey: "user_id") as? String)!
    }
    //returns the location of where the users are stored in the DB
    class func usersRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child("Users")
    }
    
    class func getUsernameById(_ userId : String, completion: @escaping (String) -> ()) {
        User.usersRef().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("username"){
                let string = snapshot.childSnapshot(forPath: "username").value as! String
                completion(string)
            }
            else{
                completion("")
            }
        })
    }
}
