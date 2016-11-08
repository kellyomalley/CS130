//
//  Wager.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase


class Wager {
    var id: String
    let idLen: Int = 16
    var userId: String
    var betAmount: Int
    var userBet: String        //for YesNo bet, should be of form 1 (Yes) or 0 (No)
    var betId: String?

    
    init(userId: String, betAmount:Int, userBet:String) {
        self.id = BBUtilities.generateObjectId(len: self.idLen)
        self.userId = userId
        self.betAmount = betAmount
        self.userBet = userBet
    }
    
    init(id: String, userId: String, betAmount:Int, userBet:String) {
        self.id = id
        self.userId = userId
        self.betAmount = betAmount
        self.userBet = userBet
    }
    
    func getUser() -> String {
        return userId
    }
    
    func getBetAmount() -> Int {
        return betAmount
    }
    
    func getUserBet() -> String {
        return userBet
    }
    
    class func wagersRef() -> FIRDatabaseReference{
        return FIRDatabase.database().reference().child("Wagers")
    }
    
}
