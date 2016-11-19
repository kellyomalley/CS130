//
//  Categories.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/18/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase

class Categories{
    
    class func getCategories(_ completion: ([(String, Int)]) -> ()){
        
        completion([("", 0)])
    }
    
    class func getBetsInCategory(_ categoryNum : Int, completion: ([Bet]) -> ()){
        completion([])
    }
    
    class func commentRef() -> FIRDatabaseReference{
        return FIRDatabase.database().reference().child("Catgories")
    }
}
