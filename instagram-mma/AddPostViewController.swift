//
//  AddPostViewController.swift
//  instagram-mma
//
//  Created by Ernie on 6/18/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import Photos


class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var taggedFriendsTextField: UITextField!
    @IBOutlet weak var userDisplayLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    let ref = FIRDatabase.database().reference()

    var imageData = NSData()
    var imageURL = NSURL()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        isUserLoggedIn()

        
    } // end of viewDidLoad
    
    func isUserLoggedIn() {
        
        // check to see if user is logged in
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                print("user IS logged in on Add Post")
                self.userDisplayLabel.text = user.uid

            } else {
                
                print("user NOT logged in")
                
            }
        }
    }

    @IBAction func onAddPostTapped(sender: UIButton) {
        
        if let user = FIRAuth.auth()?.currentUser {
            print("first level of checking if user is logged in")
            
                print("User is signed in on this VC")
                print("User ID: \(user.uid)")
                print("imageData.length > 0? :\(imageData.length)")
                print("add button method > imageURL: \(self.imageURL)")
                
                
//                let name = user.displayName
//                let email = user.email
//                let photoUrl = user.photoURL
//                let uid = user.uid;
            
                // reference to the storage service for firebase
                let storage = FIRStorage.storage()
                
                // refer to MY particular storage bucket
                let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
                
                // create random filename
                let dateformatter = NSDateFormatter()
                let randomNumber = arc4random_uniform(1000)
                
                dateformatter.dateFormat = "yyMMdd-hhmmss"
                
                let now = dateformatter.stringFromDate(NSDate())
                let final = ("\(now)-\(randomNumber)")
                print(final)
                
                // choose directory to store image on Firebase Storage
                let postPicRef = storageRef.child(user.uid+"/\(final).jpg")
                print("postPicRef: \(postPicRef)")
                
                let assets = PHAsset.fetchAssetsWithALAssetURLs([self.imageURL], options: nil)
                let asset = assets.firstObject
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
                
                // start of ADD RECORD TO FIREBASE DATABASE:
                // captionTextField, locationTextField, taggedFriendsTextField inserted
                // childByAutoId will create a unique id for the POST RECORD to be inserted
                // for the POST as well as a reference to it in the USERS POST HISTORY
                // SET VALUE: self.ref.child("users").child(user!.uid).setValue(["username": username])
                // REMINDER - Use the current UID to identify the current USERID to insert the post
                // ALSO NEED TO GENERATE A RANDOM POST ID
            
                // this will create a random key to put in the posts under "user":
                let key = ref.child("user").child("posts").childByAutoId().key
                let post = ["uid": "\(user.uid)",
                            "caption": "\(self.captionTextField!.text!)",
                            "location": "\(self.locationTextField!.text!)",
                            "friends": "\(self.taggedFriendsTextField!.text!)",
                            "imageFilename": "\(final)",
                            "postDateTime":"\(now)"]
                let childUpdates = ["/user/\(user.uid)/posts/\(key)": post,
                                    "/posts/\(key)/": post]
                ref.updateChildValues(childUpdates)
                
//                self.ref.child("user_profile").child("posts").setValue(["\(key)":["caption":"\(self.captionTextField.text)", "location":"\(self.locationTextField.text)", "friends":"\(self.taggedFriendsTextField.text)"]])

                dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                // user is not signed in
                print("User is not signed in")

            }

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
    
    
    @IBAction func onCancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
        
    
    @IBAction func onChoosePhotoTapped(sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    


}
