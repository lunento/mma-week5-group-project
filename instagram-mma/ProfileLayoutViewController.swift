//
//  ProfileLayoutViewController.swift
//  instagram-mma
//
//  Created by Ernie Barojas on 6/22/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import Firebase

class ProfileLayoutViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postCounterLabel: UILabel!
    @IBOutlet weak var followerCounterLabel: UILabel!
    @IBOutlet weak var followingCounterLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    
    private let reuseIdentifier = "cell"
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("user").child(prefs.valueForKey("userID")! as! String).child("profile").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
            // get the user info from the snpashot path above
            print(prefs.valueForKey("userID")!)
            print(snapshot)
            
            if let displayName = snapshot.value!["displayName"] as? String {
                self.displayNameLabel.text = snapshot.value!["displayName"] as! String?
            }
        })

        
        
        
        
        
        self.profileImageView.image = UIImage(named: "profileSilhouette")
        self.usernameLabel.text = "ernie.barojas ▼"
        self.postCounterLabel.text = "888"
        self.followerCounterLabel.text = "888"
        self.followingCounterLabel.text = "888"
        self.displayNameLabel.text = "Ernie B"
    
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 122, height: 122)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    
    
    

}
