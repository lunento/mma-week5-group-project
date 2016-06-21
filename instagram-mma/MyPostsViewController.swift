//
//  MyPostsViewController.swift
//  instagram-mma
//
//  Created by Ernie on 6/20/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var passedUserID: String!

    var myPosts = []
    var myDictionaryPosts:[NSDictionary] = [NSDictionary]()
    var postCaption: String?
    var postLocation: String?
    var postFriends: String?
    var postImage: String?
    
    var postRef =  FIRDatabase.database().reference().child("user").child(prefs.stringForKey("userID")!).child("posts")

    var receivedPosts = NSDictionary()
    var arrayForTable: Array = [NSDictionary]()
    var dictForTable: NSDictionary?
    
    var userID = prefs.stringForKey("userID")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                
                self.messageLabel.text = "\(self.userID!)"

                print("postRef: \(self.postRef)")
                
            } else {
                // No user is signed in.
                print("NO USER LOGGED IN!!!")
            }
        }
        
        
        self.postRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            self.arrayForTable = []
            self.receivedPosts = (snap.value as? NSDictionary)!
            
            print("self.receivedPosts: \(self.receivedPosts)")
            
            for (key, value) in self.receivedPosts {
                if let post = self.receivedPosts["\(key)"] as? NSDictionary {
                    self.arrayForTable.append(post)
                    print("POST: \(post)\n")
                }
                self.tableView.reloadData()
            }
        }
        
        self.tableView.reloadData()
    }
        

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "\(self.arrayForTable[indexPath.row].objectForKey("caption")!)"
        cell.detailTextLabel!.text = "\(self.arrayForTable[indexPath.row].objectForKey("friends")!) - \(self.arrayForTable[indexPath.row].objectForKey("location")!)"
        
        let imageFilenameFromStorage = self.arrayForTable[indexPath.row].objectForKey("imageFilename")!
        
        // download image from google storage
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
        let userStorageRef = storageRef.child(self.userID!)
        let userImageFilename = userStorageRef.child("\(imageFilenameFromStorage)" + ".jpg")
        
        print("userImageFilename: \(userImageFilename)")

        userImageFilename.dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("Error in downloading image file")
                print(error?.description)
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                cell.imageView!.image = UIImage(data: data!)
                print("the cell image is being called")
                print(data?.bytes)
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayForTable.count
    }
    

    @IBAction func onCancelButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }


    
}
