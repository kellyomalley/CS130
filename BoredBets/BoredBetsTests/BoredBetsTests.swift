//
//  BoredBetsTests.swift
//  BoredBetsTests
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import XCTest
import Firebase

@testable import BoredBets

class BoredBetsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWagerInFirebase() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        let sampleUserId = "123456"
        //user bets $1000 on yes
        tempBet.attachWager(userId: sampleUserId, betAmount: 1000, userBet: 1)
        var id: String = ""
        //Now pull all the wagers from Firebase
        //There should only be one, made by sampleUserId
        tempBet.wagerIds(completion: {
            wagerIds in
            tempBet.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
                wagers in
                for wager in wagers{
                    id = wager.getUser()
                }
            })
        })
        
        //Assert that the one present is the one we found
        XCTAssert(id == sampleUserId)
    }
    
    func testOddsCalculationDivideByZero() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        //purposely made everyone bet yes so a simple division tries to divide by zero
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: 1)
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: 1)
        let expectedResult = "Odds: 2 : 0, Pool: $3000"
        let odds = tempBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
    func testOddsCalculationZeroOnTop() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        //purposely made everyone bet yes so a simple division tries to divide by zero
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: 0)
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: 0)
        let expectedResult = "Odds: 0 : 2, Pool: $3000"
        let odds = tempBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
    func testOddsCalculationSimplify() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        //purposely made everyone bet yes so a simple division tries to divide by zero
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: 0)
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: 0)
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: 1)
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: 1)
        let expectedResult = "Odds: 1 : 1, Pool: $6000"
        let odds = tempBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }


    
}
