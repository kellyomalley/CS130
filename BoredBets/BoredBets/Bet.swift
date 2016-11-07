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
        var userIsMediator: Bool?
        var userHasWagered: Bool?
        var title: String!
        var description: String = ""
        var pot: Int?
        var wagerArray: [Wager] = []
        var lat: Double!
        var long: Double!
        var type: String!
        
        var outcome1: String! = ""
        var outcome2: String! = ""

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
        func calculateOdds() -> String{
            preconditionFailure()
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
        func getComments(_ completion: @escaping ([(String, String)]) -> ()){
            Bet.betsRef().child(self.id).child("Comments").observeSingleEvent(of: .value, with: { (snapshot) in
                var comments: [(String, String)] = []
                for commentSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let dict = commentSnap.value as? NSDictionary
                    var commentUser = ""
                    var commentText = ""
                    for (k,v) in dict!{
                        if (k as? String == "username"){
                            commentUser = v as! String
                        }
                        if (k as? String == "comment_text"){
                            commentText = v as! String
                        }
                    }
                    comments.append((commentUser, commentText))
                }
                completion(comments)
            })
        }
        
        //should be the same for every bet type
        func getCommentsCount() -> Int{
            return 0
        }
        
        //make wager and attach to the bet
        func attachWager(userId: String, betAmount: Int, userBet: Int) -> Void{
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
            User.usersRef().child(newWager.userId).child("Wagers").child(newWager.id).setValue(userWagerData)
            Bet.betsRef().child(self.id).child("Wagers").child(newWager.id).setValue(betWagerData)
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
                    var userBet: Int?
                    for (k,v) in dict!{
                        if (k as? String == "user_id"){
                            userId = v as? String
                        }
                        else if (k as? String == "bet_amount"){
                            betAmount = v as? Int
                        }
                        else if (k as? String == "user_bet"){
                            userBet = v as? Int
                        }
                        else if (k as? String == "bet_id"){
                            betId = v as? String
                        }
                    }
                    let tempWager = Wager(id: wagerId, userId: userId!, betAmount: betAmount!, userBet: userBet!)
                    tempWager.betId = betId
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
                  "mediator_id" : self.currentUserId,
                  "type" : self.type,
                  //consider changing to outcome array (to do this, would have to nest in another json object)
                  "outcome1": self.outcome1,
                  "outcome2": self.outcome2,
                  "lat": self.lat,
                  "long": self.long,
                  "pot" : 0
            ]
            
            let userBetData : [String : String] = [
                "bet_id" : betId
            ]
          //save bet in bets object
          Bet.betsRef().child(betId).setValue(betData)
            //save bet id in user object so user has reference to it
          User.usersRef().child(self.currentUserId).child("BetsMediating").child(betId).setValue(userBetData)
            
        }
    
        //returns the reference path to the where the bets are stored in the DB
        class func betsRef() -> FIRDatabaseReference{
            return FIRDatabase.database().reference().child("Bets")
        }
      }

      //the bet where something will or will not happen
      class YesNoBet: Bet {
        override init(){
            super.init()
            self.type = "YesNoBet"
        }
        /**
       Calculate bet odds for a YesNo bet, overrides main bet function.
         
         Example usage: 
        
              mybet.calcuateOdds()
        
         - Returns: A string of the form "Odds: 2:1, Pool: $1234"
       */
        override func calculateOdds() -> String{
            var numberOfYes: Int = 0
            var numberOfNo: Int = 0
            var totalPool: Int = 0
            
            for wager in wagerArray {
                totalPool += wager.getBetAmount()
                
                if wager.getUserBet() == 0 {
                    numberOfNo += 1
                }
                else if wager.getUserBet() == 1 {
                    numberOfYes += 1
                }
                else {
                    preconditionFailure("YesNo bet failure : input was not 0 or 1")
                }
            }
            
            var resString = ""
            if numberOfNo == 0 {
                resString = "Odds: \(numberOfYes) : 0, Pool: $\(totalPool)"
            }
            if numberOfYes == 0 {
                resString = "Odds: 0 : \(numberOfNo), Pool: $\(totalPool)"
            }
            else {
                let getSimple = simplify(num: numberOfYes, denom: numberOfNo)
                //return looks like Odds: 2:1, Pool: $1234
                resString = "Odds: \(getSimple.newNum) : \(getSimple.newDenom) , Pool: $\(totalPool)"
            }
            return resString
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
        override func calculateOdds() -> String{
            var totalPool: Int = 0
            let max = Int(self.outcome2)!
            let min = Int(self.outcome1)!
            
            var allWagers: [Int:Int] = [:]
            
            for index in min...max {
                allWagers[index] = 0
            }
            
            for wager in wagerArray {
                totalPool += wager.getBetAmount()
                
                allWagers[wager.getUserBet()] = allWagers[wager.getUserBet()]! + 1
            }
            var resString = "Number of wagers for each outcome: "
            for (key, value) in allWagers {
                resString += "\(key): \(value); "
            }
            resString += "Pool: \(totalPool)"
            return resString
        }
      }
      
      //the bet where something could happen a certain number of times but if you're close you still win
      class RangedBet: Bet {
        
        //override init to set type
        override init(){
            super.init()
            self.type = "RangedBet"
        }

        override func calculateOdds() -> String{
            return " "
        }
      }
      
      func simplify(num:Int, denom:Int) -> (newNum:Int, newDenom:Int) {
        
        var x: Int = num
        var y: Int = denom
        while (y != 0) {
            let temp: Int = y
            y = x % y
            x = temp
        }
        let round = x
        let newNum = num/round
        let newDenom = denom/round
        return(newNum, newDenom)
      }
      
      
