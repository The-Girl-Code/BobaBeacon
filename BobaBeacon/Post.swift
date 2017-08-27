//
//  Post.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/27/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    var likeCount: Int
    let typeOfPost: String
    let poster: User
    var isLiked = false
    let rating: String
    let location: String
    let review: String
    let drink: String
    let recommendation: String
    let deleted : Bool
    let reportedBy : String

    
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid, "username" : poster.username]
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "rating" : rating,
                "location" : location,
                "review" : review,
                "recommendation": recommendation,
                "drink": drink,
                "like_count": likeCount,
                "type_of_post": typeOfPost,
                "poster": userDict,
                "deleted" : deleted,
                "reportedBy": reportedBy]
    }
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.likeCount = 0
        self.typeOfPost = "photo"
        self.poster = User.current
        self.rating = ""
        self.review = ""
        self.location = ""
        self.drink = ""
        self.recommendation = ""
        self.deleted = false
        self.reportedBy = ""
        
    }
    
    init(rating: String, location: String, review: String) {
        self.rating = rating
        self.location = location
        self.review = review
        self.creationDate = Date()
        self.likeCount = 0
        self.typeOfPost = "review"
        self.poster = User.current
        self.imageURL = ""
        self.imageHeight = 0
        self.recommendation = ""
        self.drink = ""
        self.deleted = false
        self.reportedBy = ""
    }
    
    init(drink: String, location: String, recommendation: String) {
        self.drink = drink
        self.location = location
        self.recommendation = recommendation
        self.creationDate = Date()
        self.likeCount = 0
        self.typeOfPost = "recommendation"
        self.poster = User.current
        self.rating = ""
        self.review = ""
        self.imageURL = ""
        self.imageHeight = 0
        self.deleted = false
        self.reportedBy = ""
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let rating = dict["rating"] as? String,
            let location = dict["location"] as? String,
            let review = dict["review"] as? String,
            let recommendation = dict["recommendation"] as? String,
            let drink = dict["drink"] as? String,
            let likeCount = dict["like_count"] as? Int,
            let typeOfPost = dict["type_of_post"] as? String,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String,
            let deleted = dict["deleted"] as? Bool,
            let reportedBy = dict["reportedBy"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.likeCount = likeCount
        self.typeOfPost = typeOfPost
        self.poster = User(uid: uid, username: username)
        self.rating = rating
        self.review = review
        self.location = location
        self.recommendation = recommendation
        self.drink = drink
        self.deleted = deleted
        self.reportedBy = reportedBy
        
    }
}
