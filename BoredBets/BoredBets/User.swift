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
    static var thisUser : User? = nil
    var id:String!
    var username:String!
    var rating:Double!
    var numberRatings:Double!
    var numberComplaints:Double!
    
    init(id: String){
        self.id = id
        User.thisUser = self
    }
    
    func setUserName(name : String){
        self.username = name
        User.usersRef().child(self.id).setValue(["username": name])
    }
    
    //give an achievement to the user (store in DB)
    func add(achievement: String){
        let userRef = User.usersRef().child(self.id)
        userRef.child("Achievements").child(achievement).setValue("I'm proud of you son")
    }
    
    //returns all achievements for user
    func getAchievements(completion: @escaping([String]) -> ()){
        let userRef = User.usersRef().child(self.id)
        userRef.child("Achievements").observeSingleEvent(of: .value, with: {
            (snapshot) in
            var achievements: [String] = []
            let value = snapshot.value as? NSDictionary
            if (value != nil){
                for (k,_) in value! {
                    achievements.append(k as! String)
                }
            }
            print ("achievements: \(achievements)")
            completion(achievements)
        })
    }
    
    //User related bet object retrieval... be careful with using cause they're bad ass asynchronous calls
    //returns bets that a user has bet on that are in an active or closed state
    func activeBets(completion: @escaping ([Bet]) -> ()) {
        //returns a list of bets that the user has wagered money on
        self.activeWagerBetIds{
            betIds in
            self.betsFromIds(betIds: betIds, completion: {
                bets in
                var activeBets: [Bet] = []
                for bet in bets{
                    if bet.state != BetState.Settled{
                        activeBets.append(bet)
                    }
                }
                completion(activeBets)
            })
        }
  
    }
    
    //grab bets for user for which the user is mediating, asynchronous function call
    //only grabs bets that are *****NOT SETTLED YET****
    func activeMediatedBets (completion: @escaping ( [Bet]) -> ()){
        //returns a list of bets that the user is mediating
        //get all ids of bets the user is mediating
        self.mediatedBetIds{
            betIds in
            self.betsFromIds(betIds: betIds, completion: {
                bets in
                var activeBets: [Bet] = []
                for bet in bets{
                    if bet.state != BetState.Settled{
                        activeBets.append(bet)
                    }
                }
                completion(activeBets)
            })
            
        }
    }
    
    //gets all mediated bets for a user that have already ended
    func expiredMediatedBets(completion: @escaping ([Bet]) -> ()){
        self.mediatedBetIds{
            betIds in
            self.betsFromIds(betIds: betIds, completion: {
                bets in
                var activeBets: [Bet] = []
                for bet in bets{
                    if bet.state == BetState.Settled{
                        activeBets.append(bet)
                    }
                }
                completion(activeBets)
            })
            
        }
    }
    
    //grab betIds for user for which the user is mediating, asynchronous function call
    func mediatedBetIds(completion: @escaping ([String]) -> ()){
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
        self.wagerIds{
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
    
    //returns all wagers that are expired (given a list of wagerids that represent wagers that may or may not be expired)
    func expiredWagers(forIds: [String], wagers: [Wager],  completion: @escaping([Wager]) -> ()){
        if (forIds.count == 0){
            completion(wagers)
        }
        else{
            wager(forId: forIds[0], completion: {
                wager in
                var newWagers = wagers
                var newWagerIds = forIds
                if (wager.payout != -1){
                    newWagers.append(wager)
                }
                newWagerIds.remove(at: 0)
                self.expiredWagers(forIds: newWagerIds, wagers: newWagers, completion: {
                    wagers in
                    completion(wagers)
                })
            })
            
        }
    }
    
    //returns a wager for a wagerId
    //if there is no payout attribute on the object, payout is set to -1
    func wager(forId: String, completion: @escaping(Wager) -> ()){
        let wagerRef = Wager.wagersRef()
        wagerRef.child(forId).observeSingleEvent(of: .value, with: {(snapshot) in
            var betAmount = 0
            var payout = -1
            var betId = ""
            var userBet = ""
            
            let dict = snapshot.value as? NSDictionary
            for (k, v) in dict!{
                switch k as! String{
                    case "bet_amount":
                        betAmount = v as! Int
                    case "payout":
                        payout = v as! Int
                    case "bet_id":
                        betId = v as! String
                    case "user_bet":
                        userBet = v as! String
                    default:
                        print("other key")
                }
            }
            let wager = Wager(id: snapshot.key, userId: self.id, betAmount: betAmount, userBet: userBet)
            wager.payout = payout
            wager.betId = betId
            completion(wager)
        })
    }
    
    //grab wagerIds for user for the wagers the user has made, asynchronous function call
    func wagerIds(completion: @escaping ([String]) -> ()){
        let userRef = User.usersRef()
        //grab all betIds from the User under child ("Wagers")
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
                    var description: String = ""
                    var pot = 0
                    var type = ""
                    var outcome1 = ""
                    var outcome2 = ""
                    var userIsMediator = false
                    var mediatorId = ""
                    var state = BetState.Active
                    var payout = 0
                    var finalOutcome = ""
                    for (k,v) in dict!{
                        switch k as! String{
                            case "title":
                                title = v as! String
                            case "description":
                                description = v as! String
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
                                mediatorId = v as! String
                                print("mediator id: \(mediatorId)")
                                print("current user: \(self.id)")
                            case "settled":
                                state = BetState.Settled
                            case "finalOutcome":
                                finalOutcome = v as! String
                            case "payout":
                                payout = v as! Int
                            default:
                                print("Key: \(k as! String)")
                        }
                    }
                    let betFactory = BetFactory.sharedFactory
                    let tempBet: Bet! = betFactory.makeBet(type: type)
                    if (tempBet != nil){
                        tempBet.title = title
                        tempBet.description = description
                        tempBet.id = child.key
                        tempBet.pot = pot
                        tempBet.outcome1 = outcome1
                        tempBet.outcome2 = outcome2
                        tempBet.userIsMediator = userIsMediator
                        tempBet.mediatorId = mediatorId
                        tempBet.state = state
                        tempBet.payout = payout
                        if (finalOutcome != ""){
                            tempBet.finalOutcome = finalOutcome
                        }
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
    //only returns *******ACTIVEBETS*********
    func betsWithinVicinity(latParm: Double, longParm: Double, radMiles: Double, completion: @escaping([Bet]) -> ()){
        let betsRef = Bet.betsRef()
        betsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get bets with ids
            var bets: [Bet] = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let dict = child.value as? NSDictionary
                var title: String = "Bet"
                var description: String = ""
                var pot: Int = 0
                var lat: Double = 0
                var long: Double = 0
                var userIsMediator: Bool = false
                var mediatorId = ""
                var type: String = ""
                var outcome1: String = ""
                var outcome2: String = ""
                var category: String = ""
                
                var state: BetState = BetState.Active
                for (k,v) in dict!{
                    switch k as! String{
                        case "title":
                            title = v as! String
                        case "description":
                            description = v as! String
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
                            mediatorId = v as! String
                        case "type":
                            type = v as! String
                        case "outcome1":
                            outcome1 = v as! String
                        case "outcome2":
                            outcome2 = v as! String
                        case "settled":
                            state = BetState.Settled
                        case "category":
                            category = v as! String
                        default:
                            print("Some other key")
                    }
                }
                //check if the longitude and latitude are within the defined parms
                if (self.withinVicinity(latParm: latParm, longParm: longParm, lat: lat, long: long, radMiles: radMiles) && state == BetState.Active){
                    let betFactory = BetFactory.sharedFactory
                    let tempBet: Bet! = betFactory.makeBet(type: type)
                    if (tempBet != nil){
                        tempBet.id = child.key
                        tempBet.title = title
                        tempBet.description = description
                        tempBet.pot = pot
                        tempBet.lat = lat
                        tempBet.long = long
                        tempBet.userIsMediator = userIsMediator
                        tempBet.mediatorId = mediatorId
                        tempBet.outcome1 = outcome1
                        tempBet.outcome2 = outcome2
                        tempBet.category = category
                        bets.append(tempBet)
                    }
                }
            }
            print("Bets included in vicinity:")
            for bet in bets{
                print(bet.title)
            }
            completion(bets)
        })
        
    }
    
    func betsinCategory(selectedCategory: String, completion: @escaping([Bet]) -> ()){
        let betsRef = Bet.betsRef()
        betsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get bets with ids
            var bets: [Bet] = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let dict = child.value as? NSDictionary
                var title: String = "Bet"
                var description: String = ""
                var pot: Int = 0
                var lat: Double = 0
                var long: Double = 0
                var userIsMediator: Bool = false
                var mediatorId = ""
                var type: String = ""
                var outcome1: String = ""
                var outcome2: String = ""
                var category: String = ""
                
                var state: BetState = BetState.Active
                for (k,v) in dict!{
                    switch k as! String{
                    case "title":
                        title = v as! String
                    case "description":
                        description = v as! String
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
                        mediatorId = v as! String
                    case "type":
                        type = v as! String
                    case "outcome1":
                        outcome1 = v as! String
                    case "outcome2":
                        outcome2 = v as! String
                    case "settled":
                        state = BetState.Settled
                    case "category":
                        category = v as! String
                    default:
                        print("Some other key")
                    }
                }
                //check if the longitude and latitude are within the defined parms
                if (category == selectedCategory){
                    let betFactory = BetFactory.sharedFactory
                    let tempBet: Bet! = betFactory.makeBet(type: type)
                    if (tempBet != nil){
                        tempBet.id = child.key
                        tempBet.title = title
                        tempBet.description = description
                        tempBet.pot = pot
                        tempBet.lat = lat
                        tempBet.long = long
                        tempBet.userIsMediator = userIsMediator
                        tempBet.mediatorId = mediatorId
                        tempBet.outcome1 = outcome1
                        tempBet.outcome2 = outcome2
                        tempBet.category = category
                        
                        bets.append(tempBet)
                    }
                }
            }
            for bet in bets{
                print(bet.title)
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
    
    func allUsers(completion: @escaping([User]) -> ()){
        let userRef = User.usersRef()
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get bets with ids
            var users: [User] = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let dict = child.value as? NSDictionary
                var tid:String!
                var tusername:String!
                var trating:Double!
                var tnumberRatings:Double!
                var tnumberComplaints:Double!
                for (k,v) in dict!{
                    switch k as! String{
                    case "id":
                        tid = v as! String
                    case "username":
                        tusername = v as! String
                    case "rating":
                        trating = v as! Double
                    case "numberRatings":
                        tnumberRatings = v as! Double
                    case "numberComplaints":
                        tnumberComplaints = v as! Double
                    default:
                        print("Some other key")
                    }
                }
                
                if (true) {
                    let tempUser = User(id: child.key)
                    tempUser.username = tusername
                    tempUser.rating = trating
                    tempUser.numberRatings = tnumberRatings
                    tempUser.numberComplaints = tnumberComplaints
                    users.append(tempUser)
                }
            }
            completion(users)
        })
        
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
    
    //returns the number of bets a user has placed
    func userBetsPlaced(completion: @escaping (Int) -> ()){
        User.usersRef().child(self.id).child("bets_placed").observeSingleEvent(of: .value, with: { snapshot in
            if let betsPlaced = snapshot.value as? Int {
                completion(betsPlaced)
            }
            else {
                completion(0)
            }
            
        })
    }
    
    func incrementBetsPlaced(){
        self.userBetsPlaced(completion: {
            betsPlaced in
                User.usersRef().child(self.id).child("bets_placed").setValue(betsPlaced+1)
                //now assign achievements if numer exceeds certain bounds
            self.assignAchievements(n_bets: betsPlaced+1)
        })
    }
    
    //decides whether or not to assign achievements based on number of bets placed
    func assignAchievements(n_bets: Int){
        self.getAchievements(completion: {
            achievements in
            if (n_bets >= 3 && !achievements.contains("hatTrick")){
                self.add(achievement: "hatTrick")
            }
        })
    }
    
    //assigns achievements for possessing a certain amount of coins overall
    func assignAchievements(n_coins: Int){
        self.getAchievements(completion: {
            achievements in
            if (n_coins >= 9000 && !achievements.contains("over9000")){
                self.add(achievement: "over9000")
            }
        })
    }
    
    //assigns achievements for winning certain amount of coins in a single bet
    func assignAchievements(n_coins_in_bet: Int){
        self.getAchievements(completion: {
            achievements in
            if (n_coins_in_bet >= 100 && !achievements.contains("speedRacer")){
                self.add(achievement: "speedRacer")
            }
        })
    }
    
    //returns user's coin count
    //if no coin attribute on user, returns -1
    func userCoinCount(completion: @escaping (Int) -> ()){
        User.usersRef().child(self.id).child("coins").observe(.value, with: { snapshot in
            if let coin = snapshot.value as? Int {
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
    
    class func getUserById(_ userId : String, completion: @escaping (User) -> ()) {
        let user = User(id: userId)
        var username = ""
        var numberRatings = 0.0
        var  numberComplaints = 0.0
        User.usersRef().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("username"){
                username = snapshot.childSnapshot(forPath: "username").value as! String
            }
            if snapshot.hasChild("numberRatings"){
                numberRatings = snapshot.childSnapshot(forPath: "numberRatings").value as! Double
            }
            if snapshot.hasChild("numberComplaints"){
                numberComplaints = snapshot.childSnapshot(forPath: "numberComplaints").value as! Double
            }
            
            user.username = username
            user.numberComplaints = numberComplaints
            user.numberRatings = numberRatings
            if (numberRatings == 0){
                user.rating = 5.0
            }
            else {
                user.rating = (numberRatings - numberComplaints) / numberRatings * 5
            }
            completion(user)
        })
    }
}
