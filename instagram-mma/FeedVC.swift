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
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
         // here we get the snapshot of our database so we can retrieve our posts data and add it to our arrayForFeed
            self.postRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in self.arrayForFeed = []
            
                // We then set the array of dictionaries from FB database to a dictionary object 'receivedPosts' so we can work with it
            self.receivedPosts = (snap.value as? NSDictionary)!
            print("**********")
            print(self.receivedPosts)
            
            // We do fast enumeration to retrieve the data of posts and put them in our arrayForTable array of dictionaries
                // ASK ERNIE WHAT BELOW MEANS
            for(key, value) in self.receivedPosts {
                if let post = self.receivedPosts["\(key)"] as? NSDictionary {
                    self.arrayForFeed.append(post)
                    print(post)
                }
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()

    }


    
    override func viewWillAppear(animated: Bool) {
        tableView .reloadData()
    }

    @IBAction func onLikeButtonTapped(sender: UIButton) {
        postRef.child("post").child("likes").setValue(["uid":"\(prefs.stringForKey("userID"))"])
        print(prefs.stringForKey("userID"))
        print("*************")
        print(self.receivedPosts)
        
    }

    
    @IBAction func userNameButtonTapped(sender: UIButton) {
        
    }
    
    
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
        
//        let user = usersPassedArray[indexPath.row]
        
        cell.userNameButton.setTitle("user: \(self.arrayForFeed[indexPath.row].objectForKey("uid"))", forState: UIControlState.Normal)
//        cell.avaImage.image = user.avatar.image
//        cell.postImage.image = user.post.image
        cell.likesLabel.text = "112"
//        cell.comments.text = user.comments
        cell.comments.text = "\(self.arrayForFeed[indexPath.row].objectForKey("caption"))"
        
        
        
        
        
        
        
        
        let imageFilenameFromStorage = self.arrayForFeed[indexPath.row].objectForKey("imageFilename")
        
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
                cell.postImage!.image = UIImage(data: data!)
                cell.avaImage.image = UIImage(data: data!)
                print("the cell image is being called")
                print(data?.bytes)
            }
        }

        return cell
        

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

    }
    

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
