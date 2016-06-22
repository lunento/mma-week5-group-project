//
//  ViewController.swift
//  ProjectOCCoreData
//
//  Created by Pasha Bahadori on 6/19/16.
//  Copyright © 2016 Pelican Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController {
    var usersArray = [User]()
    // Here we instantiate and create a child branch called "condition"
    
    
    let ref = FIRDatabase.database().reference()
    
//    let conditionRef = ref.child("condition")
//    let fir = FIRApp.configure
    @IBOutlet weak var conditionLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let kendallPic = "Kendall2.jpg"
        let kendallImage = UIImage(named: kendallPic)
        let emiliaPic = "Emilia2.jpg"
        let emiliaImage = UIImage(named: emiliaPic)
        let rockPic = "Rock2.jpg"
        let rockImage = UIImage(named: rockPic)
        
        let kendall = User(withName: "kendallovesP", avatar:UIImageView(image: kendallImage!), post: UIImageView(image: kendallImage!), likes: "120", comments: "I think about Pasha everyday \u{1F496} \u{1F496}")
        
        let emilia = User(withName: "ItsEmiliaaa", avatar:UIImageView(image: emiliaImage!), post: UIImageView(image: emiliaImage!), likes: "19,001", comments: "#Raw #Uncut")
        
        let rock = User(withName: "TheRock", avatar:UIImageView(image: rockImage!), post: UIImageView(image: rockImage!), likes: "12,320", comments: "If ya smell")
        usersArray = [kendall, emilia, rock]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let users = self.usersArray
        if let fvc = segue.destinationViewController as? FeedVC{
            fvc.usersPassedArray = users
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        ref.child("posts").child("Mohammed").child("nameid").setValue("KingHabibi")
        
    }
}

