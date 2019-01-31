//
//  ViewController.swift
//  RM Wedding
//
//  Created by Rayen on 10/21/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Auth.auth().signInAnonymously() { (authResult, error) in
        }
         self.ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func pressJoin(_ sender: Any) {
        showInputDialog()
    }
    
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter Wedding ID", message: "", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text ?? "none"
            
            self.ref.child("weddings").child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    print("true rooms exist")
                    let defaults = UserDefaults.standard
                    defaults.set(name, forKey: "wedding")
                    defaults.synchronize()
                    self.performSegue(withIdentifier: "tabView", sender: Any?.self)
                }else{
                    print("false room doesn't exist")
                    let alertController = UIAlertController(title: "Wedding does not exist", message:
                        "Please check with organizer for correct ID", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }) 
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Wedding ID"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }

}

