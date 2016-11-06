//
//  BetFactory.swift
//  BoredBets
//
//  Created by Markus Notti on 11/5/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation

class BetFactory{
    //singleton factory, should be accessed by BetFactory.sharedFactory
    static let sharedFactory = BetFactory()
    private init(){}
    //manufactures the correct subclass of bet given the bet type input string
    func makeBet(type: String) -> Bet?{
        switch type{
            case "YesNoBet":
                return YesNoBet()
            case "RangedBet":
                return RangedBet()
            case "ExactNumericalBet":
                return ExactNumericalBet()
            default:
                print("ERROR in bet factory: '\(type)' is not a supported bet type")
                return nil
        }
    }
    
    //returns a list of the supported bet types
    class func supportedBetTypes() -> [String]{
        return ["YesNoBet", "RangedBet", "ExactNumericalBet"]
    }
    
    //input a bet type (from one of the supported bet types), and get back the user display for that type
    class func betTypeUserDisplay(type: String) -> String?{
        switch type{
            case "YesNoBet":
                return "Yes/No Bet"
            case "RangedBet":
                return "Ranged Bet"
            case "ExactNumericalBet":
                return "Specific number bet"
            default:
                print("ERROR in bet factory user display type: '\(type)' is not a supported bet type")
                return nil
        }
    }
}
