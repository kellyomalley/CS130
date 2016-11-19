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
    let betId: String
    var commentText: String
    var timestamp: Double
    
    //Constructor w/o a set id (creates a timestamp upon creation)
    init(userId: String, betId: String, commentText:String) {
        self.id = BBUtilities.generateObjectId(len: self.idLen)
        self.userId = userId
        self.commentText = commentText
        self.betId = betId
        self.timestamp = NSDate().timeIntervalSinceReferenceDate
    }
    
    //Constructor w/ a set id (creates a timestamp upon creation)
    init(id: String, userId: String, betId: String, commentText:String) {
        self.id = id
        self.userId = userId
        self.commentText = commentText
        self.betId = betId
        self.timestamp = NSDate().timeIntervalSinceReferenceDate
    }
    
    /**
     Save a comment to the database and calls completion upon completion
     
     Example usage:
     
        comment.saveComment(funcToCallUponCompletion)
     
        - Parameter completion: the function to call when saving is finished
     */
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
}
