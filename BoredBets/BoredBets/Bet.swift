      //
     //  Bet.swift
    //  BoredBets
   //
  //  Created by Markus Notti on 10/23/16.
 //  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation


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
        func attatchComment() -> Void{
            
        }
        
        //make a list of wagers attatched to the bet
        func attatchWager(userId: Int, betAmount: Int, userBet: Int) -> Void{
            let newWager = Wager(userId: userId, betAmount: betAmount, userBet: userBet)
            wagerArray.append(newWager)
            
        }
      }

      //the bet where something will or will not happen
      class YesNoBet: Bet {
        override func calculateOdds() -> String{
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
      
      
