//
//  CameraViewController.swift
//  RM Wedding
//
//  Created by Rayen on 10/23/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import ProgressHUD


class CameraViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
     var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handlePhotoSelection() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    

    @IBAction func photoBtn(_ sender: Any) {
        handlePhotoSelection()
    }
    @IBAction func share(_ sender: Any) {
        // show the progress to the user
        ProgressHUD.show("Sharing started...", interaction: false)
        
        // convert selected image to JPEG Data format to push to file store
        if let photo = selectedImage, let imageData = UIImageJPEGRepresentation(photo, 0.90) {
            
            // get a unique ID
            let photoIDString = NSUUID().uuidString
            
            // get a reference to our file store
            let kUserDefault = UserDefaults.standard
            let weddingID = kUserDefault.string(forKey: "wedding")
            let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child(weddingID!).child("photos").child(photoIDString + ".jpg")
            
            // push to file store
            _ = storeRef.putData(imageData, metadata: nil) { (metadata, error) in
                // You can also access to download URL after upload.
                storeRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    // if there's no error
                    // get the URL of the photo in the file store
                    let photoURL = downloadURL.absoluteString
                    
                    // and put the photoURL into the database
                    self.saveToDatabase(photoURL: photoURL)
                }
            }
    }
    }
 
    func saveToDatabase(photoURL: String) {
        let kUserDefault = UserDefaults.standard
        let weddingID = kUserDefault.string(forKey: "wedding")
        let ref = Database.database().reference()
        let postsReference = ref.child("weddings").child(weddingID!).child("photos")
        let newPostID = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostID)
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        newPostReference.setValue(["uid": currentUserID,"photoURL": photoURL]) { (error, reference) in
            if error != nil {
                ProgressHUD.showError("Photo Save Error: \(error?.localizedDescription ?? "Error")")
                return
            }
            
            ProgressHUD.showSuccess("Photo shared")
            
        
            // and jump to the Home tab
            self.tabBarController?.selectedIndex = 0
        }
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = image
            selectedImage = image
        }
        
        dismiss(animated: true)
    }
    
}
