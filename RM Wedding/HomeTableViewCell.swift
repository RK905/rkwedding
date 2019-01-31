//
//  HomeTableViewCell.swift
//  RM Wedding
//
//  Created by Rayen on 10/23/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseAuth
import Kingfisher
import QuartzCore

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var buttonSav:UIButton!
 
    
    var homeVC: GalleryViewController?
    var postReference: DatabaseReference!
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView() {
  
        if let photoURL = post?.photoURL {
            let url = URL(string: photoURL)
            postImageView.kf.setImage(with: url)
        }
        

    }
    
    // flush the user profile image before a reuse
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBAction func savePhoto(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(postImageView.image!, nil, nil, nil )
        buttonSav.titleLabel?.text = "Saved"
        buttonSav.backgroundColor? = Color.green
    }
    
    
}

