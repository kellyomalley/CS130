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
    
    var id: String
    let idLen: Int = 16
    var userId: String
    var commentText: String
    var betId: String?
    
    
    init(userId: String, betId: String, commentText:String) {
        self.id = BBUtilities.generateObjectId(len: self.idLen)
        self.userId = userId
        self.commentText = commentText
        self.betId = betId
    }
    
    init(id: String, userId: String, betId: String, commentText:String) {
        self.id = id
        self.userId = userId
        self.commentText = commentText
        self.betId = betId
    }
    
    func getUser() -> String {
        return userId
    }
    
    func getCommentText() -> String {
        return commentText
    }
    
    class func commentRef() -> FIRDatabaseReference{
        return FIRDatabase.database().reference().child("Comments")
    }
    
}
