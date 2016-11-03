//
//  Comment.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/1/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import Firebase

class Comment{
    
    let id: String
    let idLen: Int = 16
    let userId: String
    var username: String
    let betId: String
    var commentText: String
    var timestamp: Double
    
    
    init(userId: String, betId: String, commentText:String) {
        self.id = BBUtilities.generateObjectId(len: self.idLen)
        self.userId = userId
        self.commentText = commentText
        self.betId = betId
        self.timestamp = NSDate().timeIntervalSinceReferenceDate
        self.username = ""
        User.getUsernameById(userId, completion: { (name) in
            self.username = name
        })
    }
    
    init(id: String, userId: String, betId: String, commentText:String) {
        self.id = id
        self.userId = userId
        self.commentText = commentText
        self.betId = betId
        self.timestamp = NSDate().timeIntervalSinceReferenceDate
        self.username = ""
        User.getUsernameById(userId, completion: { (name) in
            self.username = name
        })
    }
    
    func saveComment(_ completion: @escaping () -> ()){
        User.getUsernameById(userId, completion: { (name) in
            let commentData: [String: Any] = [
                "id" : self.id,
                "user_id" : self.userId,
                "comment_text" : self.commentText,
                "username" : name,
                "timestamp" : self.timestamp
            ]
            Bet.betsRef().child(self.betId).child("Comments").child(self.id).setValue(commentData)
            completion()
        })
    }
    
    class func commentRef() -> FIRDatabaseReference{
        return FIRDatabase.database().reference().child("Comments")
    }
}
