//
//  PostAPI.swift
//  RM Wedding
//
//  Created by Rayen on 10/23/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//

import Foundation
import Firebase


class PostAPI {
    
    let kUserDefault = UserDefaults.standard
    var REF_POSTS = Database.database().reference()
    
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS = Database.database().reference().child("weddings").child(kUserDefault.string(forKey: "wedding")!).child("photos")
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let postDictionary = snapshot.value as? [String: Any] {
                
                let newPost = Post.transformPost(postDictionary: postDictionary, key: snapshot.key)
                
                completion(newPost)
            }
        }
    }
    
    func observePost(withID id:String, completion: @escaping (Post) -> Void) {
               REF_POSTS = Database.database().reference().child("weddings").child(kUserDefault.string(forKey: "wedding")!).child("photos")
        REF_POSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let postDictionary = snapshot.value as? [String:Any] {
                let post = Post.transformPost(postDictionary: postDictionary, key: snapshot.key)
                completion(post)
            }
        })
    }
    
}
