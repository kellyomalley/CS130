//
//  Utilities.swift
//  BoredBets
//
//  Created by Markus Notti on 10/27/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase

//global enums here:
//consider putting this enum in Bet model, but it works here!
enum BetState{
    case Active, Closed, Settled
}

class BBUtilities{
    
    //generates random string that can be used to represent any object ID
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
    
    class func translateFirebaseTimestamp(timeSince: TimeInterval) -> NSDate{ // Read the value at the
        return NSDate(timeIntervalSince1970: timeSince/1000)
    }
    
    class func showMessagePrompt(_ message: String, title: String = "Oops!", controller: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func showOverlay(view: UIView) -> UIView {
        let overlay = UIView(frame: view.frame)
        overlay.center = view.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        view.addSubview(overlay)
        view.bringSubview(toFront: overlay)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        UIView.commitAnimations()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.center = overlay.center
        indicator.startAnimating()
        overlay.addSubview(indicator)
        
        return overlay
    }
    
    class func removeOverlay(overlay: UIView) {
        overlay.removeFromSuperview()
    }
}
