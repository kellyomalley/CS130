//
//  BetMarker.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import GoogleMaps

class BetMarker: GMSMarker {
    var bet: Bet!
    init(bet :Bet) {
        self.bet = bet
        super.init()
    }
}
