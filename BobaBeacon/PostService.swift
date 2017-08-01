//
//  PostService.swift
//  BobaBeacon
//
//  Created by Kodo on 7/27/17.
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
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        let dict = post.dictValue
        let postRef = Database.database().reference().child("posts").child("photos").childByAutoId()
        postRef.updateChildValues(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil)

    }
    
    static func show(forKey postKey: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child("photos").child(postKey)
        
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
}
