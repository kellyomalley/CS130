//
//  BetInfoWindow.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation


class BetInfoWindow: UIView {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var pot: UILabel!
    @IBOutlet var showBet: UIButton!
    
    var map: Map!
    var bet: Bet!
}
