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
    
    func testWagerSaving() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        let sampleUserId = "123456"
        //user bets $1000 on yes
        tempBet.attachWager(userId: sampleUserId, betAmount: 1000, userBet: "1")
        var id: String = ""
        for wager in tempBet.wagerArray {
            id = wager.getUser()
        }
        //Assert that the one present is the one we found
        XCTAssert(id == sampleUserId)
    }
    
    func testOddsCalculationDivideByZero() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.outcome1 = "0"
        tempBet.outcome2 = "1"
        tempBet.id = "tempID"
        //purposely made everyone bet yes so a simple division tries to divide by zero
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: "1")
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: "1")
        let expectedResult = "Odds: 2 : 0, Pool: $3000"
        let odds = tempBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
    func testOddsCalculationZeroOnTop() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.outcome1 = "0"
        tempBet.outcome2 = "1"
        tempBet.id = "tempID"
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: "0")
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: "0")
        let expectedResult = "Odds: 0 : 2, Pool: $3000"
        let odds = tempBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
    func testOddsCalculationSimplify() {
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        tempBet.outcome1 = "0"
        tempBet.outcome2 = "1"
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: "0")
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: "0")
        tempBet.attachWager(userId: "15234", betAmount: 2000, userBet: "1")
        tempBet.attachWager(userId: "65453", betAmount: 1000, userBet: "1")
        let expectedResult = "Odds: 1 : 1, Pool: $6000"
        let odds = tempBet.calculateOdds()
        
        XCTAssert(expectedResult == odds)
    }
    
    func testLocationClose() {
        let testUser: User = User(id: "testUser")
        let userLat: Double = 100
        let userLong: Double = 100
        let betLat: Double = 100.2
        let betLong: Double = 100.1
        let radius: Double = 16
        
        let result = testUser.withinVicinity(latParm: userLat, longParm: userLong, lat: betLat, long: betLong, radMiles: radius)
        
        XCTAssertTrue(result)
        
    }
    
    func testLocationFar() {
        let testUser: User = User(id: "testUser")
        let userLat: Double = 100
        let userLong: Double = 100
        let betLat: Double = 101
        let betLong: Double = 102
        let radius: Double = 16
        
        let result = testUser.withinVicinity(latParm: userLat, longParm: userLong, lat: betLat, long: betLong, radMiles: radius)
        
        XCTAssertFalse(result)
    }
    
    func testAddingCommentFirebase() {
        // this test invloves manually looking in Firebase
        let betFactory = BetFactory.sharedFactory
        let tempBet: Bet! = betFactory.makeBet(type: "YesNoBet")
        tempBet.id = "tempID"
        tempBet.outcome1 = "0"
        tempBet.outcome2 = "1"
        
        let testComment: Comment = Comment(id: "HERE", userId: "HERE", betId: "HERE", commentText: "LOOK HERE FOR TEST RESULTS")
        
        testComment.saveComment({ print("Completed") })
        // there's no assert since this test is meant to test writing to Firebase
        // after running I look in the database and see that this comment is present
       
    }
    
}
