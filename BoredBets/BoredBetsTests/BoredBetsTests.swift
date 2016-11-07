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
        let myTestBet = YesNoBet(title: "Testing the bet class!")
        let sampleUserId = "123456"
        //user bets $1000 on yes
        myTestBet.attachWager(userId: sampleUserId, betAmount: 1000, userBet: 1)
        var id: String = ""
        //Now pull all the wagers from Firebase
        //There should only be one, made by sampleUserId
        myTestBet.wagerIds(completion: {
            wagerIds in
            myTestBet.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
                wagers in
                for wager in wagers{
                    id = wager.getUser()
                }
            })
        })
        
        //Assert that the one present is the one we found
        XCTAssert(id == sampleUserId)
    }
    
    func testOddsCalculation() {
        let myTestBet = YesNoBet(title: "Testing the bet class!")
        //purposely made everyone bet yes so a simple division tries to divide by zero
        myTestBet.attachWager(userId: "15234", betAmount: 2000, userBet: 1)
        myTestBet.attachWager(userId: "65453", betAmount: 1000, userBet: 1)
        let expectedResult = "Odds: 1:0, Pool: $3000"
        let odds = myTestBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
}
