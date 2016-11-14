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
    var payout: Int?

    
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
    
    func getBet(completion: @escaping(Bet) -> ()){
        let betRef = Bet.betsRef().child(betId!)
        betRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get bets with ids
        let dict = snapshot.value as? NSDictionary
        var title: String = "Bet"
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
            case "pot":
                pot = v as! Int
            case "type":
                type = v as! String
            case "outcome1":
                outcome1 = v as! String
            case "outcome2":
                outcome2 = v as! String
            case "mediator_id":
                if (v as! String == User.currentUser()){
                    userIsMediator = true
                }
                mediatorId = v as! String
            case "settled":
                state = BetState.Settled
            case "payout":
                payout = v as! Int
            case "finalOutcome":
                finalOutcome = v as! String
            default:
                print("Some other key")
            }
        }
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: type)
        if (tempBet != nil){
            tempBet.title = title
            tempBet.id = self.betId
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
        }
            completion(tempBet)
        })
        
    }
    
    class func wagersRef() -> FIRDatabaseReference{
        return FIRDatabase.database().reference().child("Wagers")
    }
    
}
