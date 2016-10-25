      //
     //  Bet.swift
    //  BoredBets
   //
  //  Created by Markus Notti on 10/23/16.
 //  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation

      
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
        var id: Int
        var title: String
        var description: String = ""
        var wagerArray: [Wager] = []

        //no description
        init(id: Int, title: String) {
            self.id = id
            self.title = title
        }
        
        // description
        init(id: Int, title: String, description: String) {
            self.id = id
            self.title = title
            self.description = description
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
      
      
