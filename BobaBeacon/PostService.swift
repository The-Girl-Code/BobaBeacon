//
//  PostService.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/27/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)

        }
    }
    
    static func createProfilePic(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
            
        }
    }
    
    static func createRec(drink: String, location: String, recommendation: String) {
        let currentUser = User.current
        let post = Post(drink: drink, location: location, recommendation: recommendation)
        let dict = post.dictValue
        let postRef = Database.database().reference().child("posts").childByAutoId()
        postRef.updateChildValues(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil)
        
    }
    

    
     static func createReview(rating: String, location: String, review: String) {
        let currentUser = User.current
        let post = Post(rating: rating, location: location, review: review)
        let dict = post.dictValue
        let postRef = Database.database().reference().child("posts").childByAutoId()
        postRef.updateChildValues(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil)
        
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        let dict = post.dictValue
        let postRef = Database.database().reference().child("posts").childByAutoId()
        postRef.updateChildValues(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil)

    }
    
    private static func createProfilePic(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        let dict = post.dictValue
        let postRef = Database.database().reference().child("users").child(currentUser.uid).child("profilePic")
        postRef.updateChildValues(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil)
        
    }

    
    static func show(forKey postKey: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(postKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
//          LikeService.isPostLiked(post) { (isLiked) in
//                post.isLiked = isLiked
//                completion(post)
//            }
        })
    }
    
    static func flag(_ post: Post) {
        print("got here!")

        guard let postKey = post.key else { return }
        print("got here!2")
        let flaggedPostRef = Database.database().reference().child("flaggedPosts").child(postKey)
        let flaggedDict = ["image_url": post.imageURL,
                           "poster_uid": post.poster.uid,
                           "reporter_uid": User.current.uid]
        flaggedPostRef.updateChildValues(flaggedDict)
        let flagCountRef = flaggedPostRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            if ((currentCount + 1) > 2) {
                let ref = Database.database().reference()
                ref.child("posts").child(post.key!).removeValue()
                
            }

            return TransactionResult.success(withValue: mutableData)
        })
    }
}
