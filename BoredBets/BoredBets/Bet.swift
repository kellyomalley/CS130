      //
     //  Bet.swift
    //  BoredBets
   //
  //  Created by Markus Notti on 10/23/16.
 //  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase

      
//README: Here's a summary of how I'm implementing this: Bet is the superclass that the three bet types inherit from.
      //All bets have common characteristics, like comments and people betting on them, but they operate differently
      //in how they calculate odds and such.
      //calculateOdds() is overriden in all derived classes
      //TO MAKE A WAGER: wagers are attached to the bet and are created using attachWager()
      //Must give the user, amount to bet, and what the actual bet is
      //The Bet class keeps track of all the wagers. These are then used for finding odds


// need to figure out how to refactor to make this fit a design pattern
      //bets can be contructed passing in a bet id, bet title, bet description, and bet type
      //description is optional
      

      //maybe template method?
      
      class Bet {
        var id: String!
        let idLen : Int = 16
        var currentUserId : String!
        var mediatorId: String!
        var userIsMediator: Bool?
        var userHasWagered: Bool?
        var title: String!
        var description: String = ""
        var pot: Int = 0
        var wagerArray: [Wager] = []
        var lat: Double!
        var long: Double!
        var type: String!
        var isGlobal: Bool = false
        var category: String = ""
        
        var outcome1: String! = ""
        var outcome2: String! = ""
        var finalOutcome: String! = ""
        var state: BetState = BetState.Active
        var payout: Int?

        init(){
            //for default init in createBet VC
            self.currentUserId = User.currentUser()
        }
        
        //no description
        init(title: String) {
            self.title = title
            self.currentUserId = User.currentUser()
        }
        
        // description
        init(title: String, id: String) {
            self.title = title
            self.id = id
            self.currentUserId = User.currentUser()
        }
        
        //with id (for when we pull from the database and want to store one particular bet as a bet object...
        init(id: String, title: String, description: String) {
            self.id = id
            self.title = title
            self.description = description
            self.currentUserId = User.currentUser()
        }
       
        //should always be overridden
        func calculateOdds(_ completion : @escaping (String) -> ()){
            preconditionFailure()
        }
        
        //returns a list of winning wagers
        func determineWinners(wagers: [Wager]) -> [Wager]{
            preconditionFailure("determineWinners() should be overridden by subclasses")
        }
        
        //given a list of wagers, returns a dictionary with the users to be paid out corresponding to the amount which they should be paid
        func assignWinnings(winners: [Wager]) -> [String:Int]{
            print("ENTERED ASSIGN WINNINGS")
            print("Pot: \(self.pot)")
            var mediatorCut = Int(Double(self.pot)*0.1)
            let potAfterMediatorCut = self.pot - mediatorCut
            var potRemaining = potAfterMediatorCut
            var winnersContribution = 0
            for winner in winners {
                winnersContribution += winner.betAmount
            }
            print("Winners Contribution: \(winnersContribution)")
            var winnings: Dictionary = [String:Int]()
            for winner in winners{
                print("winner: \(winner)")
                let tempWinnings = Int((Double(winner.betAmount)/Double(winnersContribution)) * Double(potAfterMediatorCut))
                if (winnings[winner.userId] != nil){
                    winnings[winner.userId]! += tempWinnings
                }
                else{
                    winnings[winner.userId] = tempWinnings

                }
                potRemaining -= tempWinnings
            }
            //if any left with rounding, give to mediator
            if (potRemaining > 0){
                mediatorCut += potRemaining
                potRemaining = 0
            }
            winnings[User.currentUser()] = mediatorCut
            print("IN ASSIGN WINNINGS")
            print("winnings: \(winnings)")
            print("pot: \(self.pot)")
            print("EXITING ASSIGN WINNINGS")
            return winnings
        }
        
        //given a dictionary of (userIds, earnings), payout those users the amounts specified
        func distributeWinnings(winnings: [String:Int], completion: @escaping() -> ()){
            if (winnings.count > 0){
                var newWinnings = winnings
                let userId = winnings.keys[winnings.startIndex]
                User.usersRef().child(userId).child("coins").observeSingleEvent(of: .value, with: { (snapshot) in
                    var coins = snapshot.value as! Int
                    let coins_gained = newWinnings[userId]!
                    coins += coins_gained
                    User.usersRef().child(userId).child("coins").setValue(coins)
                    print("Gave \(coins_gained) coins to user \(userId)")
                    //check if user gets any new achievements:
                    User(id:userId).assignAchievements(n_coins: coins)
                    //User(id:userId).assignAchievements(n_coins_in_bet: coins_gained)
                    //continue distributing winnings
                    newWinnings.removeValue(forKey: newWinnings.keys[newWinnings.startIndex])
                    self.distributeWinnings(winnings: newWinnings, completion: {
                        completion()
                    })
                })
            }
            else{
                completion()
            }
        }
        
        //updates the DB to indicate that the bet has concluded and assigns it a final outcome
        //updates the wager objects to show a final return on their bet:
            //losers get 0 as payout
            //winners get their winnings
        func concludeBet(losers: [Wager], winners: [Wager], winnings: [String:Int], numParticipants: Int){
            //update losers' wagers to give them a payout of 0
            updateNumberParticipants(numParticipants: numParticipants)
            for loser in losers{
                updateWagerPaidOut(wager: loser, payout: 0)
            }
            
            //update winners' wagers to give them correct payout...
            for winner in winners{
                if let payout = winnings[winner.userId]{
                    updateWagerPaidOut(wager: winner, payout: payout)
                }
            }
            
            //update the bet object to mark as settled
            Bet.betsRef().child(self.id).child("settled").setValue(FIRServerValue.timestamp())
            //update the bet object to include the payout to the mediator
            let mediatorPayout = winnings[self.currentUserId]
            self.payout = mediatorPayout
            Bet.betsRef().child(self.id).child("payout").setValue(mediatorPayout)
            
        }
        
        //updates a wager with 'payout' attribute
        func updateWagerPaidOut(wager: Wager, payout: Int){
            Wager.wagersRef().child(wager.id).child("payout").setValue(payout)
            
                //check if the user with the wager made enough money to earn himself an achievement
            let user = User(id:wager.userId)
            let coins_gained = payout - wager.betAmount
            user.assignAchievements(n_coins_in_bet: coins_gained)
            
        }
        
        func updateNumberParticipants(numParticipants: Int) {
            User.usersRef().child(self.mediatorId).child("numberRatings").observeSingleEvent(of: .value, with: { snapshot in
                var value = snapshot.value as! Int
                value = value + numParticipants
                User.usersRef().child(self.mediatorId).child("numberRatings").setValue(value)
            })
        }
        
        //should be the same for every bet type
        func attachComment(_ commentText : String, completion: @escaping () -> ()){
            let comment = Comment(userId: User.currentUser(), betId: self.id, commentText: commentText)
            comment.saveComment(completion)
        }
        
        //should be the same for every bet type
        /**
            Asynchronously gets the comments for this bet.
         
            Example usage:
         
                bet.getComments(funcToCallUponCompletion)
        
            - Parameter completion: the function to call when retrieval is finished. This is passed a tuple of usernames and their corresponding comments
         */
        func getComments(_ completion: @escaping ([(String, String, Double)]) -> ()){
            Bet.betsRef().child(self.id).child("Comments").observeSingleEvent(of: .value, with: { (snapshot) in
                var comments : [(String, String, Double)] = []
                for commentSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let dict = commentSnap.value as? NSDictionary
                    var commentUser = ""
                    var commentText = ""
                    var timestamp : Double = 0
                    for (k,v) in dict!{
                        if (k as? String == "username"){
                            commentUser = v as! String
                        }
                        if (k as? String == "comment_text"){
                            commentText = v as! String
                        }
                        if (k as? String == "timestamp"){
                            timestamp = v as! Double
                        }
                    }
                    comments.append((commentUser, commentText, timestamp))
                }
                
                comments.sort(by: { $0.2 > $1.2 })
                
                completion(comments)
            })
        }
        
        //should be the same for every bet type
        func getCommentsCount() -> Int{
            return 0
        }
        
        //make wager and attach to the bet
        func attachWager(userId: String, betAmount: Int, userBet: String) -> Void{
            let newWager = Wager(userId: userId, betAmount: betAmount, userBet: userBet)
            wagerArray.append(newWager)
            //now update the db with the new wager object
            self.saveNewWager(newWager)
            self.updatePot()
        }
        
        //saves a new wager object to the DB given that object and an associated bet object
        func saveNewWager(_ newWager: Wager){
            let wagerData: [String: Any] = [
                "user_id" : newWager.userId,
                "bet_id" : self.id,
                "bet_amount" : newWager.betAmount,
                "user_bet" : newWager.userBet
            ]
            
            let userWagerData: [String: String] = [
                "wager_id" : newWager.id
            ]
            
            let betWagerData: [String: String] = [
                "wager_id" : newWager.id
            ]
            Wager.wagersRef().child(newWager.id).setValue(wagerData)
            Bet.betsRef().child(self.id).child("Wagers").child(newWager.id).setValue(betWagerData)
            User.usersRef().child(newWager.userId).child("Wagers").child(newWager.id).setValue(userWagerData)
            //update 'bets_placed'
            let user = User(id: newWager.userId)
            user.incrementBetsPlaced()
        }
        
        //function updates the pot in the bet object by tallying up all associated wagers
        func updatePot(){
            self.wagerIds(completion: {
                wagerIds in
                self.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
                    wagers in
                    var pot = 0
                    for wager in wagers{
                        pot += wager.betAmount
                    }
                    Bet.betsRef().child(self.id).child("pot").setValue(pot)
                })
            })
        }
        
        func closeBetting(){
            //TODO - updates the bet so no users can bet
        }
        
        func settleBet(bet: Bet, completion: @escaping() -> ()){
            self.wagerIds(completion: { wagerIds in
                self.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: { wagers in
                    let numParticipants = wagers.count
                    let winners = self.determineWinners(wagers: wagers)
                    let losers = self.removeWagers(wagers: winners, from: wagers)
                    let winnings = self.assignWinnings(winners: winners)
                    self.distributeWinnings(winnings: winnings, completion: {
                        self.concludeBet(losers: losers, winners: winners, winnings: winnings, numParticipants: numParticipants)
                        completion()
                    })
                })
            })
        }
        
        //removes wagers in list 1 from list 2
        //returns the resulting wager list
        func removeWagers(wagers: [Wager], from: [Wager]) -> [Wager]{
            var newWagers = from
            for wager in wagers{
                newWagers = removeWager(forId: wager.id, from: newWagers)
            }
            return newWagers
        }
        
        //removes a wager from a given wager list for a certain wager id
        //returns the wager list without the removed wager
        func removeWager(forId: String, from: [Wager]) -> [Wager]{
            var newWagers = from
            for (i, wager) in newWagers.enumerated(){
                if (wager.id == forId){
                    newWagers.remove(at: i)
                    return newWagers
                }
            }
            return newWagers
        }
        
        //function returns all wagers given a list of wager ids
        func wagersForWagerIds(wagerIds: [String], wagers: [Wager], completion: @escaping([Wager]) -> ()){
            let wagersRef = Wager.wagersRef()
            if (wagers.count == wagerIds.count){
                completion(wagers)
            }
            else{
                let index = wagers.count
                wagersRef.child(wagerIds[index]).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    let wagerId: String = wagerIds[index]
                    var userId: String?
                    var betId: String?
                    var betAmount: Int?
                    var userBet: String?
                    var payout = 0
                    for (k,v) in dict!{
                        if (k as? String == "user_id"){
                            userId = v as? String
                        }
                        else if (k as? String == "bet_amount"){
                            betAmount = v as? Int
                        }
                        else if (k as? String == "user_bet"){
                            userBet = v as? String
                        }
                        else if (k as? String == "bet_id"){
                            betId = v as? String
                        }
                        else if(k as? String == "payout"){
                            payout = v as! Int
                        }
                    }
                    let tempWager = Wager(id: wagerId, userId: userId!, betAmount: betAmount!, userBet: userBet!)
                    tempWager.betId = betId
                    tempWager.payout = payout
                    var newWagers = wagers
                    newWagers.append(tempWager)
                    self.wagersForWagerIds(wagerIds: wagerIds, wagers: newWagers, completion: {
                        wagers in
                        completion(wagers)
                    })
                })
            }

        }
        
        //gets wagerIds for wagers that have been placed on a bet
        func wagerIds(completion: @escaping([String]) -> ()){
            let betsRef = Bet.betsRef()
            betsRef.child(self.id).child("Wagers").observeSingleEvent(of: .value, with: { (snapshot) in
                var wagerIds: [String] = []
                for wagerSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let dict = wagerSnap.value as? NSDictionary
                    var wagerId: String = "wager_id"
                    for (k,v) in dict!{
                        if (k as? String == "wager_id"){
                            wagerId = v as! String
                        }
                    }
                    wagerIds.append(wagerId)
                }
                completion(wagerIds)
            })
        }

        //saves the bet object to the DB
        func saveNewBetToFB() -> Void {
            let betId = BBUtilities.generateObjectId(len: idLen)
            //set bet ID for bet object
            self.id = betId
            let betData : [String: Any] = [
                  "title" : self.title,
                  "description" : self.description,
                  "mediator_id" : self.currentUserId,
                  "type" : self.type,
                  //consider changing to outcome array (to do this, would have to nest in another json object)
                  "outcome1": self.outcome1,
                  "outcome2": self.outcome2,
                  "lat": self.lat,
                  "long": self.long,
                  "pot" : 0,
                  "category" :  self.category
            ]
            
            let userBetData : [String : String] = [
                "bet_id" : betId
            ]
            
          //save bet in bets object
          Bet.betsRef().child(betId).setValue(betData)
            //save bet id in user object so user has reference to it
          User.usersRef().child(self.currentUserId).child("BetsMediating").child(betId).setValue(userBetData)
          if self.category != "" {
               Categories.categoriesRef().child(category).child(betId).setValue(betId)
          }
            
        }
    
        //returns the reference path to the where the bets are stored in the DB
        class func betsRef() -> FIRDatabaseReference{
            return FIRDatabase.database().reference().child("Bets")
        }
        
        //returns a betObject for a dictionary corresponding to the db arrangement of bet
        class func betForDBDict(dict: NSDictionary, betId: String) -> Bet{
            
            var category: String = ""
            var description: String = ""
            var finalOutcome: String?
            var lat: Double = 0
            var long: Double = 0
            var mediatorId = ""
            var outcome1: String = ""
            var outcome2: String = ""
            var payout: Int?
            var pot: Int = 0
            var state: BetState = BetState.Active
            var title: String = "Bet"
            var type: String = ""
            var userIsMediator: Bool = false
           
            for (k,v) in dict{
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
                    if (v as! String == User.currentUser()){
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
                case "finalOutcome":
                    finalOutcome = v as! String
                case "payout":
                    payout = v as! Int
                default:
                    print("Some other key")
                }
            }
            let betFactory = BetFactory.sharedFactory
            let tempBet: Bet! = betFactory.makeBet(type: type)
            if (tempBet != nil){
                tempBet.id = betId
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
                tempBet.state = state
                if (finalOutcome != nil){
                    tempBet.finalOutcome = finalOutcome
                }
                if (payout != nil){
                    tempBet.payout = payout
                }
                else if (state == BetState.Settled){
                    tempBet.payout = 0
                }
            }
            return tempBet

        }
      }

      //the bet where something will or will not happen
      class YesNoBet: Bet {
        override init(){
            super.init()
            self.type = "YesNoBet"
        }
        override func determineWinners(wagers: [Wager]) -> [Wager] {
            print("ENTERED Determine winners")
            var winners: [Wager] = []
            for wager in wagers{
                print("Wager: \(wager.userBet), Final Outcome: \(self.finalOutcome)")
                if (wager.userBet == self.finalOutcome){
                    winners.append(wager)
                }
            }
            print("RETURNING WINNERS: \(winners)")
            print("Exiting determine winners")
            return winners
        }
        /**
       Calculate bet odds for a YesNo bet, overrides main bet function.
         
         Example usage: 
        
              mybet.calcuateOdds()
        
         - Returns: A string of the form "Odds: 2:1, Pool: $1234"
       */
        override func calculateOdds(_ completion : @escaping (String) -> ()){
            self.wagerIds(completion: {
                wagerIds in
                self.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
                    wagers in
                    
                    var numberOfYes: Int = 0
                    var numberOfNo: Int = 0
                    
                    for wager in wagers{
                        if wager.getUserBet() == self.outcome1 {
                            numberOfYes += wager.betAmount
                            print("got a yes")
                        }
                        else if wager.getUserBet() == self.outcome2 {
                            numberOfNo += wager.betAmount
                            print("got a no")
                        }
                    }
                    var resString = ""
                    if numberOfNo == 0 {
                        resString = "Odds: \(numberOfYes) : 0"
                    }
                    else if numberOfYes == 0 {
                        resString = "Odds: 0 : \(numberOfNo)"
                    }
                    else {
                        let getSimple = simplify(num: numberOfYes, denom: numberOfNo)
                        //return looks like Odds: 2:1, Pool: $1234
                        resString = "Odds: \(getSimple.newNum) : \(getSimple.newDenom)"
                    }
                    completion(resString)
                })
            })
        }
      }
      
      //the bet where something must happen a certain number of times
      class ExactNumericalBet: Bet {
        //override init to set type
        override init(){
            super.init()
            self.type = "ExactNumericalBet"
        }
        
        /**
         Calculate bet odds for a ExactNumerical bet, overrides main bet function.
         
            Example usage:
         
                mybet.calcuateOdds()
         
         - Returns: A string of the form "Number of wagers for each outcome: 2: 0; 3: 1; 4: 3; Pool: $1234"
         */
        override func calculateOdds(_ completion : @escaping (String) -> ()){
            
            self.wagerIds(completion: {
                wagerIds in
                self.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
                    wagers in
                    let max = Int(self.outcome2)!
                    let min = Int(self.outcome1)!
                    
                    let allWagers: NSDictionary = [:]
                    
                    for index in min...max {
                        allWagers.setValue(0, forKey: String(index))
                    }
                    
                    for wager in wagers{
                        
                        let betGuess = wager.getUserBet()
                        allWagers.setValue(allWagers[betGuess] as! Int + wager.getBetAmount(), forKey: String(betGuess))
                        var resString : String = "Bet Distribution: \n| "
                        for (_, value) in allWagers {
                            resString += "\(value) | "
                        }
                        completion(resString)
                    }
                })
            })
        }
        
        override func determineWinners(wagers: [Wager]) -> [Wager] {
            let minOutcome = Int(self.outcome1)!
            let maxOutcome = Int(self.outcome2)!
            let finalOutcome = Int(self.finalOutcome!)!
            var winners: [Wager] = []
            var minDifference = maxOutcome - minOutcome
            for wager in wagers{
                let diff = abs(Int(wager.userBet)! - finalOutcome)
                if (diff < minDifference){
                    minDifference = diff
                }
            }
            for wager in wagers{
                let diff = abs(Int(wager.userBet)! - finalOutcome)
                if (diff == minDifference){
                    winners.append(wager)
                }
            }
            return winners
        }
      }
      
      //the bet where something could happen a certain number of times but if you're close you still win
      class RangedBet: Bet {
        
        //override init to set type
        override init(){
            super.init()
            self.type = "RangedBet"
        }

        override func calculateOdds(_ completion : @escaping (String) -> ()){
        }
      }
      
      func simplify(num:Int, denom:Int) -> (newNum:Int, newDenom:Int) {
        func gcdfunc(_ a: Int, _ b: Int) -> Int {
            if b == 0 {
                return a
            } else {
                if a > b {
                    return gcdfunc(a-b, b)
                } else {
                    return gcdfunc(a, b-a)
                }
            }
        }
        
        let gcd = gcdfunc(num, denom)
        return(num / gcd, denom / gcd)
      }
      
