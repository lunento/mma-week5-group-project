//
//  ProfileViewController.swift
//  instagram-mma
//
//  Created by Ernie Barojas on 6/21/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    // need ref to use as a master reference to our Firebase database
    let ref = FIRDatabase.database().reference()
    
    let imagePicker = UIImagePickerController()
    
    var imageData = NSData()
    var imageURL = NSURL()
    
    let userid = prefs.stringForKey("userID")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.debugLabel.text = "prefs.userID: \(prefs.stringForKey("userID")!)"
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("user").child(userID!).child("profile").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            print(snapshot)
            
            if let website = snapshot.value!["website"] as? String {
                self.websiteTextField.text = snapshot.value!["website"] as! String?
            }
            
            if let displayName = snapshot.value!["displayName"] as? String {
                self.displayNameTextField.text = snapshot.value!["displayName"] as! String?
            }
            
            if let bio = snapshot.value!["bio"] as? String {
                self.bioTextView.text = snapshot.value!["bio"] as! String?
            }
            
            
            
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        getImage()
        
    }
    
    func getImage() {
        
        // GET IMAGE FROM GOOGLE FIREBASE STORAGE:
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
        let userStorageRef = storageRef.child(self.userid)
        let userImageFilename = userStorageRef.child("profile.jpg")
        
        print("userImageFilename: \(userImageFilename)")
        
        userImageFilename.dataWithMaxSize(3 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("Error in downloading image file")
                print(error?.description)
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                self.imageView.image = UIImage(data: data!)
                self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                
                print("the cell image is being called")
                print(data?.bytes)
            }
        }
        // END GET IMAGE FROM GOOGLE FIREBASE STORAGE - ABOVE
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            self.imageData = UIImageJPEGRepresentation(pickedImage, 1.0)!
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            self.imageURL = imageURL
            print("imageURL: \(imageURL)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func onAddProfilePhotoTapped(sender: UIButton) {
        
        print("onAddProfilePhotoTapped...")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func onUpdateProfileButtonTapped(sender: UIButton) {
        
        print("onUpdateProfileButtonTapped ...")
        
        // prefs.stringForKey("userID")! is from the NSUserDefaults pref value stored for the userID (user.uid):
        
        let profilePath = self.ref.child("user").child(prefs.stringForKey("userID")!).child("profile")
        
        profilePath.child("displayName").setValue("\(self.displayNameTextField.text!)")
        
        profilePath.child("website").setValue("\(self.websiteTextField.text!)")
        
        profilePath.child("bio").setValue("\(self.bioTextView.text!)")
        
        
        self.savedLabel.hidden = false
        self.savedLabel.alpha = 1.0
        UIView.animateWithDuration(0.5, delay: 2.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.savedLabel.alpha = 0.0
        }) { (Bool) in
            self.savedLabel.hidden = true
        }
        
        
        // START STORING THE PROFILE IMAGE:
        // reference to the storage service for firebase
        let storage = FIRStorage.storage()
        
        // refer to MY particular storage bucket
        let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
        
        // choose directory to store image on Firebase Storage
        let postPicRef = storageRef.child(self.userid+"/profile.jpg")
        print("postPicRef: \(postPicRef)")
        
        let assets = PHAsset.fetchAssetsWithALAssetURLs([self.imageURL], options: nil)
        print(assets)
        let asset = assets.firstObject
        print(asset)
        asset?.requestContentEditingInputWithOptions(nil, completionHandler: { (contentEditingInput, info) in
            let imageFile = contentEditingInput!.fullSizeImageURL
            print("imageFile: \(imageFile)")
            
            let uploadTask = postPicRef.putFile(imageFile!, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print("error in upload")
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata!.downloadURL
                    print("downloadURL metadata: \(downloadURL)")
                }
            } // end of uploadTask
            
        }) // end of requestContentEditingInputWithOptions
        
        
        // update the profile image path
        profilePath.child("profilePhoto").setValue("profile.jpg")
        
        
    }
    
    @IBAction func onDoneButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}
