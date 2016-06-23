//
//  FeedVC.swift
//  newsFeedIG
//
//  Created by Pasha Bahadori on 6/20/16.
//  Copyright © 2016 Pelican Inc. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UITableViewController {
    var usersPassedArray = [User]()
    
    var postRef =  FIRDatabase.database().reference().child("posts")
    var arrayForFeed: Array = [NSDictionary]()
    var receivedPosts = NSDictionary()
    var userID = prefs.stringForKey("userID")
 
    @IBOutlet weak var likesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedArray()
        self.tableView.reloadData()

    }

    func loadFeedArray() {
        // here we get the snapshot of our database so we can retrieve our posts data and add it to our arrayForFeed
        self.postRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in self.arrayForFeed = []
            
            // We then set the array of dictionaries from FB database to a dictionary object 'receivedPosts' so we can work with it
            self.receivedPosts = (snap.value as? NSDictionary)!
//            print("**********")
//            print(self.receivedPosts)
            
            // We do fast enumeration to retrieve the data of posts and put them in our arrayForTable array of dictionaries
            // ASK ERNIE WHAT BELOW MEANS
            for(key, value) in self.receivedPosts {
                if let post = self.receivedPosts["\(key)"] as? NSDictionary {
                    self.arrayForFeed.append(post)
//                    print(post)
                }
                self.tableView.reloadData()
            }
        }
    }
    


    
    override func viewWillAppear(animated: Bool) {
        tableView .reloadData()
    }

//    func onLikeButtonTapped(sender: UIButton) {
////        postRef.child("post").child("likes").setValue(["uid":"\(prefs.stringForKey("userID"))"])
////        print(prefs.stringForKey("userID"))
//        print("On Like Button Tapped")
////        print(self.receivedPosts)
//        
//    }

    
    @IBAction func userNameButtonTapped(sender: UIButton) {
        
    }
    
    
    
    func onLikeButtonTapped(sender: UIButton) {
        print("On Like Button Tapped")
    }
    
//    
//    @IBAction func likesTapped(sender: UIButton) {
//       print("likesTapped executed")
//       print(sender.tag)
//       print(self.receivedPosts.allValues[0])
//    
//        
//        // we have an array of
//    }
    
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayForFeed.count
    }

    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! CellTableViewCell
        
// ------------------------------- SETTING USER'S DISPLAY NAME --------------------------------------------
        // creating user reference so I can set the displayName of the user to my news feed when they post
        var userRef =  FIRDatabase.database().reference().child("user")
        var arrayForUsers: Array = [NSDictionary]()
        var receivedUsers = NSDictionary()

        
        // Check out prefs.valueForKey("userID)
        userRef.child(prefs.valueForKey("userID")! as! String).child("profile").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            // get the user info from the snapshot path above
//            print(prefs.valueForKey("userID")!)
//            print(snapshot)
            
            
            
            if let displayName = snapshot.value!["displayName"] as? String {
                print("***************************")
                print(displayName)
//                cell.userNameButton.setTitle(snapshot.value!["displayName"], forState: UIControlState.Normal)
//                cell.displayNameLabel.text = snapshot.value!["displayName"] as! String?
            }
        })
        
// -------------------------------- USER'S INFO --------------------------------------------------------'
        
        
//        cell.userNameButton.setTitle("user: \(self.arrayForUsers[indexPath.row].objectForKey("displayName")!)", forState: UIControlState.Normal)

        cell.likesLabel.text = "112"
        cell.comments.text = "\(self.arrayForFeed[indexPath.row].objectForKey("caption")!)"
        
        
        
        // make reference to the userProfile, like in above, it's going - make a reference to below path but set the objectForKey to displayName
        cell.userNameButton.setTitle("\(self.arrayForFeed[indexPath.row].objectForKey("uid")!)", forState: UIControlState.Normal)
        
        cell.likesButton!.tag = indexPath.row
        
        // print("arrayForFeed:")
        // print(self.arrayForFeed[indexPath.row])
        
        // Trying to figure out to make the like button work
        self.likesButton?.addTarget(self, action: "onLikeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let imageFilenameFromStorage = self.arrayForFeed[indexPath.row].objectForKey("imageFilename")
//            print(self.arrayForFeed[indexPath.row])
        // download image from google storage
        let storage = FIRStorage.storage()
        
        
        // the URL in this is the URL that shows above the image directories for Firebase Storage
        // -----------------------POST IMAGES -----------------------------------------------------
        let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
        let userPath = self.arrayForFeed[indexPath.row].objectForKey("uid")
        let userStorageRef = storageRef.child("\(userPath!)")
        let userImageFilename = userStorageRef.child("\(imageFilenameFromStorage!)" + ".jpg")
        
        print("userImageFilename: \(userImageFilename)")
        print(self.arrayForFeed[indexPath.row].objectForKey("uid"))
        
        userImageFilename.dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
//                print("Error in downloading image file")
//                print(error?.description)
            } else {
                cell.postImage!.image = UIImage(data: data!)
//                print("the cell image is being called")
//                print(data?.bytes)
            }
        }
        // -----------------------------------------------------------------------------------------
        
        // ------------------------ AVATAR IMAGES --------------------------------------------------
        let profilePicRef = userStorageRef.child("/profile.jpg")
        print("profilePicRef")
        print(profilePicRef)
        
        profilePicRef.dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print("Error in downloading image file")
                print(error?.description)
            } else {
                cell.avaImage.image = UIImage(data: data!)
                print("the cell image AVATAR is being called")
                print(data?.bytes)
            }
        }
        
        
        return cell
    }
    
//        
//        cell.textLabel!.text = "\(self.arrayForTable[indexPath.row].objectForKey("caption")!)"
//        cell.detailTextLabel!.text = "user: \(self.arrayForTable[indexPath.row].objectForKey("uid")!)  postDateTime: \(self.arrayForTable[indexPath.row].objectForKey("postDateTime"))"
//        
//        let imageFilenameFromStorage = self.arrayForTable[indexPath.row].objectForKey("imageFilename")!
//        
//        // download image from google storage
//        let storage = FIRStorage.storage()
//        let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
//        let userStorageRef = storageRef.child(self.userID!)
//        let userImageFilename = userStorageRef.child("\(imageFilenameFromStorage)" + ".jpg")
//        
//        print("userImageFilename: \(userImageFilename)")
//        
//        
//        userImageFilename.dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
//            if (error != nil) {
//                // Uh-oh, an error occurred!
//                print("Error in downloading image file")
//                print(error?.description)
//            } else {
//                // Data for "images/island.jpg" is returned
//                // ... let islandImage: UIImage! = UIImage(data: data!)
//                cell.imageView!.image = UIImage(data: data!)
//                print("the cell image is being called")
//                print(data?.bytes)
//            }
//        }
//        return cell

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
