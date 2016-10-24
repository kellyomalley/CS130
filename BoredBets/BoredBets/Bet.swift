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
        var type: String

        //no description
        init(id: Int, title: String, type: String) {
            self.id = id
            self.title = title
            self.type = type
        }
        
        // description
        init(id: Int, title: String, description: String, type:String) {
            self.id = id
            self.title = title
            self.description = description
            self.type = type
        }
       
        //should always be overridden
        func calculateOdds() -> String{
                preconditionFailure()
        }
      }
