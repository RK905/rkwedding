//
//  Post.swift
//  RM Wedding
//
//  Created by Rayen on 10/23/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//


import Foundation
import FirebaseAuth


class Post {
    var photoURL: String?
    var uid: String?
    var id: String?

}

extension Post {
    
    static func transformPost(postDictionary: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.id = key
        post.photoURL = postDictionary["photoURL"] as? String
        post.uid = postDictionary["uid"] as? String
        
        return post
    }
    
}
