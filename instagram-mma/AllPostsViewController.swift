//
//  AllPostsViewController.swift
//  instagram-mma
//
//  Created by Ernie on 6/20/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import Firebase

class AllPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postRef =  FIRDatabase.database().reference().child("posts").queryOrderedByChild("postDateTime")
    
    var arrayForTable: Array = [NSDictionary]()
    var receivedPosts = NSDictionary()
    var userID = prefs.stringForKey("userID")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // here we retrieve the snaptshot of our databse so we can setup retrieving our posts data and adding it to our arrayForTable
        self.postRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
        
            self.arrayForTable = []
            self.receivedPosts = (snap.value as? NSDictionary)!
            
            print(self.receivedPosts)
            
            // We do fast enumeration to retrieve the data of posts and put them in our arrayForTable array of dictionaries
            for(key, value) in self.receivedPosts {
                if let post = self.receivedPosts["\(key)"] as? NSDictionary {
                    self.arrayForTable.append(post)
                    print(post)
                }
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "\(self.arrayForTable[indexPath.row].objectForKey("caption")!)"
        cell.detailTextLabel!.text = "user: \(self.arrayForTable[indexPath.row].objectForKey("uid")!)  postDateTime: \(self.arrayForTable[indexPath.row].objectForKey("postDateTime"))"
        
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
    
    
    // this dismisses the allPosts view controller
    @IBAction func onCancelButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayForTable.count
}


}




