//
//  Wager.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation


class Wager {
    var userId: Int
    var betAmount: Int
    //for YesNo bet, should be of form 1 (Yes) or 0 (No)
    var userBet: Int
    
    init(userId: Int, betAmount:Int, userBet:Int) {
        self.userId = userId
        self.betAmount = betAmount
        self.userBet = userBet
    }
    
    func getUser() -> Int {
        return userId
    }
    
    func getBetAmount() -> Int {
        return betAmount
    }
    
    func getUserBet() -> Int {
        return userBet
    }
    
}
