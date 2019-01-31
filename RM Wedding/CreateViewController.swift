//
//  CreateViewController.swift
//  RM Wedding
//
//  Created by Rayen on 10/22/18.
//  Copyright © 2018 geeksdobyte. All rights reserved.
//

import UIKit
import MaterialComponents
import FirebaseDatabase

class CreateViewController: UIViewController {

    
    @IBOutlet weak var weddingIdTV: MDCTextField!
    
    
    @IBOutlet weak var createWedding: UIButton!
    
    
    @IBOutlet weak var copyWeddingID: UIButton!
    
    var ref: DatabaseReference!
    var mystring:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()

    }
    
    @IBAction func pressCreate(_ sender: UIButton) {
        mystring = randomAlphaNumericString(length: 6)
        let child = ["key":mystring]
        let sample = ["mini" :"https://cuisinierscater.com/wedding-catering-images/orlando-catering-classic-menu.jpg","large":"https://cuisinierscater.com/wedding-catering-images/orlando-catering-classic-menu.jpg"]
        self.ref.child("weddings").child(mystring).setValue(child)
        self.ref.child("weddings").child(mystring).child("photos").childByAutoId().setValue(sample)
        weddingIdTV.text = mystring
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = mystring
    }
    
    @IBAction func pressCopy(_ sender: UIButton) {
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = mystring
        let defaults = UserDefaults.standard
        defaults.set(mystring, forKey: "wedding")
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}
