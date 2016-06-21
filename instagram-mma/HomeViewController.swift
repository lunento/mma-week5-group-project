//
//  HomeViewController.swift
//  instagram-mma
//
//  Created by Ernie on 6/16/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {

    @IBOutlet weak var uiimvProfilePic: UIImageView!
    @IBOutlet weak var uilName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.uiimvProfilePic.layer.cornerRadius = self.uiimvProfilePic.frame.size.width/2
        
        self.uiimvProfilePic.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            if let user = FIRAuth.auth()?.currentUser {
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid;
                
                self.uilName.text = name
                
//                let data = NSData(contentsOfURL: photoUrl!)
//                self.uiimvProfilePic.image = UIImage(data: data!)
                
                // reference to the storage service for firebase
                let storage = FIRStorage.storage()
                
                // refer to MY particular storage bucket
                let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
                
                let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print("There was an error in downloading image")
                        
                    } else {
                        // Data for "images/island.jpg" is returned
                        // ... let islandImage: UIImage! = UIImage(data: data!)
                        
                        if(data != nil) {
                            
                            print("User already has an image, no need to download from facebook.")
                            self.uiimvProfilePic.image = UIImage(data: data!)
                        }
                        
                    }
                }
                
                if(self.uiimvProfilePic.image == nil) {
                    
                    
                    var profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300, "redirect":false], HTTPMethod: "GET")
                    profilePic.startWithCompletionHandler({(connection, result, error) -> Void in
                        // Handle the result
                        
                        if(error == nil)
                        {
                            print(result)
                            let dictionary = result as? NSDictionary
                            let data = dictionary?.objectForKey("data")
                            
                            let urlPic = (data?.objectForKey("url"))! as! String
                            
                            // if we get an image, we want to upload the image to our storage
                            if let imageData = NSData(contentsOfURL: NSURL(string: urlPic)!)
                            {
                                
                                // upload the image
                                let uploadTask = profilePicRef.putData(imageData, metadata:nil){
                                    metadata, error in
                                    
                                    if(error == nil)
                                    {
                                        //we can get the size, content type or download url
                                        let downloadUrl = metadata!.downloadURL
                                        
                                    } else {
                                        
                                        print("Error in downloading image.")
                                        
                                    }
                                }
                                
                                //update the image
                                
                                self.uiimvProfilePic.image = UIImage(data:imageData)
                                
                            }
                        }
                        
                    })
                    
                }// end of if
                
            } else {
                // No user is signed in.
            }
            
        }
    }
    
        
    @IBAction func didTapLogout(sender: AnyObject) {
        
        // signs the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        //sign the user out of the facebook app
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(viewController, animated: true, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
