//
//  Utilities.swift
//  BoredBets
//
//  Created by Markus Notti on 10/27/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation

class BBUtilities{
    
    
    class func generateObjectId(len : Int) -> String {
        //TODO
        //insert logic to check if such a string already exists...
        //(do in each individual class)
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0...len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
}
