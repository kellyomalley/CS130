//
//  BoredBetsTests.swift
//  BoredBetsTests
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import XCTest

@testable import BoredBets

class BoredBetsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let myTestBet = YesNoBet(title: "Testing the bet class!")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWagerInFirebase() {
        let sampleUserId = "123456"
        //user bets $1000 on yes
        myTestClass.attachWager(userId: sampleUserId, betAmount: 1000, userBet: 1)
        var id: String = ""
        //Now pull all the wagers from Firebase
        //There should only be one, made by sampleUserId
        myTestClass.wagerIds(completion: {
            wagerIds in
            self.wagersForWagerIds(wagerIds: wagerIds, wagers: [], completion: {
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
        //purposely made everyone bet yes so a simple division tries to divide by zero
        myTestClass.attachWager(userId: "15234", betAmount: 2000, userBet: 1)
        myTestClass.attachWager(userId: "65453", betAmount: 1000, userBet: 1)
        let expectedResult = "Odds: 1:0, Pool: $3000"
        let odds = myTestClass.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
}
