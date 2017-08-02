//
//  TextPost.swift
//  BobaBeacon
//
//  Created by Kodo on 8/2/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class ReviewPost {
    var key: String?
    let rating: String
    let location: String
    let review: String
    let creationDate: Date
    var likeCount: Int
    let reviewPost: String
    let poster: User
    var isLiked = false
    
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid, "username" : poster.username]
        return ["rating" : rating,
                "location" : location,
                "review" : review,
                "created_at" : createdAgo,
                "like_count": likeCount,
                "type_of_post": reviewPost,
                "poster": userDict]
    }
    
    init(rating: String, location: String, review: String) {
        self.rating = rating
        self.location = location
        self.review = review
        self.creationDate = Date()
        self.likeCount = 0
        self.reviewPost = "review"
        self.poster = User.current
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let rating = dict["rating"] as? String,
            let location = dict["location"] as? String,
            let review = dict["review"] as? String,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let likeCount = dict["like_count"] as? Int,
            let reviewPost = dict["type_of_post"] as? String,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.rating = rating
        self.location = location
        self.review = review
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.likeCount = likeCount
        self.reviewPost = reviewPost
        self.poster = User(uid: uid, username: username)
    }
    
    
    
    
}
