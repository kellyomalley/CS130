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
        let betsRef = FIRDatabase.database().reference().child("Bets")
        let usersRef = FIRDatabase.database().reference().child("Users")
        let idLen : Int = 16
        var currentUserId : String?
        
        var id: Int?
        var title: String?
        var description: String = ""
        var wagerArray: [Wager] = []

        init(){
            //for default init in createBet VC
            self.currentUserId = UserDefaults.standard.object(forKey: "user_id") as? String
        }
        
        //no description
        init(title: String) {
            self.title = title
            self.currentUserId = UserDefaults.standard.object(forKey: "user_id") as? String
        }
        
        // description
        init(title: String, description: String) {
            self.title = title
            self.description = description
            self.currentUserId = UserDefaults.standard.object(forKey: "user_id") as? String
        }
        
        //with id (for when we pull from the database and want to store one particular bet as a bet object...
        init(id: Int, title: String, description: String) {
            self.id = id
            self.title = title
            self.description = description
            self.currentUserId = UserDefaults.standard.object(forKey: "user_id") as? String
        }
       
        //should always be overridden
        func calculateOdds() -> String{
            preconditionFailure()
        }
        
        //should be the same for every bet type
        func attachComment() -> Void{
            
        }
        
        //make a list of wagers attatched to the bet
        func attachWager(userId: Int, betAmount: Int, userBet: Int) -> Void{
            let newWager = Wager(userId: userId, betAmount: betAmount, userBet: userBet)
            wagerArray.append(newWager)
            
        }
        
        func saveNewBetToFB() -> Void {
            let betId = self.generateBetId(len: idLen)
            let betData : [String: String] = [
                  "title" : self.title!,
                  "mediator_id" : self.currentUserId!
            ]
            
            let userBetData : [String : String] = [
                "title" : self.title!
            ]
          
          betsRef.child(betId).setValue(betData)
          usersRef.child(self.currentUserId!).child("BetsMediating").child(betId).setValue(userBetData)
        }
        
        func generateBetId(len : Int) -> String {
            //TODO
            //insert logic to check if such a string already exists...
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
            let randomString : NSMutableString = NSMutableString(capacity: len)
            
            for _ in 0...len{
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.character(at: Int(rand)))
            }
            
            return randomString as String
        }
      }

      //the bet where something will or will not happen
      class YesNoBet: Bet {
        override func calculateOdds() -> String{
            var numberOfYes: Int = 0
            var numberOfNo: Int = 0
            
            for wager in wagerArray {
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
            
            //TODO: use numberOfNo and numberOfYes to actually calc the odds
            
            return " "
        }
      }
      
      //the bet where something must happen a certain number of times
      class ExactNumericalBet: Bet {
        override func calculateOdds() -> String{
            return " "
        }
      }
      
      //the bet where something could happen a certain number of times but if you're close you still win
      class RangedBet: Bet {
        override func calculateOdds() -> String{
            return " "
        }
      }
      
      
