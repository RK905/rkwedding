//
//  GalleryViewController.swift
//  RM Wedding
//
//  Created by Rayen on 10/23/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
        //tableView.delegate = self
        tableView.dataSource = self
        loadPosts()
        // Do any additional setup after loading the view.
    }
    
  
    func loadPosts() {
        activityIndicatorView.startAnimating()
        
        API.Post.observePosts { (newPost) in
            guard let userID = newPost.uid else { return }
            self.fetchUser(uid: userID, completed: {
                // append the new Post and Reload after the user
                // has been cached
                self.posts.append(newPost)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
  completed()
    }
    

}

extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        cell.post = posts[indexPath.row]
        cell.homeVC = self

        return cell
    }
    
}
