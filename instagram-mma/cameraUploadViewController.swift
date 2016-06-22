//
//  cameraUploadViewController.swift
//  ig_camera
//
//  Created by Rolando Guerra on 6/20/16.
//  Copyright © 2016 Rolando R Guerra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import Photos

class cameraUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    let ref = FIRDatabase.database().reference()
    
    ///UI Objects///
    
    //imaged picked will show the picked image from camera or cameraRoll library
    @IBOutlet weak var imagePicked: UIImageView!
    
    //titleTxt is the caption text for the picture/post
    @IBOutlet weak var titleTxt: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Do any additional setup after loading the view.
        
        //setting up place holder text in comment textView
        titleTxt.text = "Write a caption"
        titleTxt.textColor = UIColor.lightGrayColor()
        
        // select from camera roll by tapping on imageView
        let picTap = UITapGestureRecognizer(target: self, action: "selectImg")
        picTap.numberOfTapsRequired = 1
        imagePicked.userInteractionEnabled = true
        imagePicked.addGestureRecognizer(picTap)
        
   
    }    //←end of viewDidLoad
    
    @IBAction func onAddPostTapped(sender: UIButton) {
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
        }) // end of requestContentEditingInputWithOptions  ←end of image storage
        
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
        
    
}





    // func to call pickerViewController
    func selectImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }

    
    //Open camera button
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Open photo from photo library or camera roll
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //show our image in our image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //save image
    @IBAction func saveButt(sender: AnyObject) {
        var imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        var compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Wow",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
    
    //gets rid of keyboard if you tap blank space
    @IBAction func goAwayKeyboard(sender: AnyObject) {
    titleTxt.resignFirstResponder()
    }
    
    //Gets rid of placeholder text in caption textView
    @IBAction func onTextViewTapped(sender: AnyObject) {
        if titleTxt.text == "Write a caption" {
            titleTxt.textColor = UIColor.blackColor()
            titleTxt.text = ""
        }
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
