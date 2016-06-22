//
//  FirebaseAuthViewController.swift
//  instagram-mma
//
//  Created by Ernie on 6/20/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

let prefs = NSUserDefaults.standardUserDefaults()

class FirebaseAuthViewController: UIViewController {

    @IBOutlet weak var userLoginStatusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginMessageLabel: UILabel!
    
    @IBOutlet weak var allPostButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var myPostButton: UIButton!
    @IBOutlet weak var updateProfileButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var userid = prefs.stringForKey("userID")
    
    
    // Password *MUST* be a minimum of 6 characters
    // let email = "ernie1@test.com"
    // let password = "123456789"

    override func viewDidLoad() {
        super.viewDidLoad()

    isUserLoggedIn()
        
        self.loginMessageLabel.hidden = true
        self.addPostButton.hidden = true
        self.allPostButton.hidden = true
        self.myPostButton.hidden = true
        self.profileImageView.hidden = true
        self.updateProfileButton.hidden = true
        
        
    }
    
    @IBAction func onLogoutTapped(sender: UIButton) {
    
        logout()
        isUserLoggedIn()
        
    }

    @IBAction func createUser(sender: UIButton) {
        
        // this will create a user with Firebase auth
        FIRAuth.auth()?.createUserWithEmail(self.emailTextField.text!, password: self.passwordTextField.text!) {
            user, error in

            if error != nil {
                
                // the account was not found or the account is completely wrong
                self.login()
                
                
            } else {
                
                // the user was created!
                print("User was created!")
                
                // need to add the fields to firebase
//                let profilePath = FIRDatabase.database().reference().ref.child("user").child(prefs.stringForKey("userID")!).child("profile")
//                profilePath.child("displayName").setValue("")
//                profilePath.child("website").setValue("")
//                profilePath.child("bio").setValue("")
                

                self.login()
                
            }
        
        }
        
    }
    
    func logout() {
        try! FIRAuth.auth()!.signOut()
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
//        prefs.setValue("", forKey: "userID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userID")
        print("LOGOUT...")
        print("LOGOUT > prefs.valueForKey userid: \(prefs.valueForKey("userID"))")
//        print("LOGOUT > self.userid: \(self.userid)")
    }
    
    func login() {
        
        // this will login the user
        FIRAuth.auth()?.signInWithEmail(self.emailTextField.text!, password: self.passwordTextField.text!
            , completion: {
                user, error in
            
            if error != nil {
                
                print("There was some sort of error logging in using the email/password provided  ")
                self.loginMessageLabel.hidden = false
                self.loginMessageLabel.text = "There was some sort of error logging in. \n Please try again"
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                prefs.setValue("", forKey: "userID")

                
            } else {
                print("YEAH! LOGGED IN OK.....")
                self.loginMessageLabel.hidden = false
                self.loginMessageLabel.text = "You're Logged In!"
                self.loginMessageLabel.backgroundColor = UIColor.greenColor()
                self.addPostButton.hidden = false
                self.allPostButton.hidden = false
                self.myPostButton.hidden = false
                prefs.setValue("\(user!.uid)", forKey: "userID")
                print("LOGIN > prefs.valueForKey user.uid: \(prefs.valueForKey("userID"))")
                print("LOGIN > user.uid: \(user!.uid)")
                self.refreshProfileImage()

            }
        })
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshProfileImage()
    }
    
    func refreshProfileImage() {

        if prefs.valueForKey("userID") != nil {
            
        // GET IMAGE FROM GOOGLE FIREBASE STORAGE:
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://instagram-mma.appspot.com")
        let userStorageRef = storageRef.child("\(prefs.valueForKey("userID")!)")
        let userImageFilename = userStorageRef.child("profile.jpg")
        
//        print("self.userid: \(self.userid)")
        print("prefs.valueForKey userID: \(prefs.valueForKey("userID"))")
        print("userImageFilename: \(userImageFilename)")
        
        userImageFilename.dataWithMaxSize(3 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("Error in downloading image file")
                print(error?.description)
                self.profileImageView.image = UIImage(named: "white")
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                self.profileImageView.image = UIImage(data: data!)
                self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
                print("the cell image is being called")
                print(data?.bytes)
            }
        }
        // END GET IMAGE FROM GOOGLE FIREBASE STORAGE - ABOVE
        } else {
            self.profileImageView.image = UIImage(named: "white")
        }

    }
    
    func isUserLoggedIn() {
        
        // check to see if user is logged in
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                // User is signed in.
                print("user is signed in")
                self.userLoginStatusLabel.text = ""
                self.loginButton.hidden = true
                self.logoutButton.hidden = false
                self.emailTextField.hidden = true
                self.passwordTextField.hidden = true
                self.addPostButton.hidden = false
                self.allPostButton.hidden = false
                self.myPostButton.hidden = false
                self.profileImageView.hidden = false
                self.updateProfileButton.hidden = false
                
//                if let user = FIRAuth.auth()?.currentUser {
//                    // User is signed in.
//                    // display currentUser name
//                    self.usernameLabel.text = "currentUser: \(user)\nEmail: \(user.email!)\nUID: \(user.uid)\nDisplayName: \(user.displayName)"
//
//                    
//                    self.refreshProfileImage()
//                
//                    
//                } else {
//                    
//                    // No user is signed in.
//                    self.usernameLabel.text = ""
//                    self.logoutButton.hidden = true
//                    self.loginButton.hidden = false
//                    self.profileImageView.hidden = true
//                }
//                
//                if let user = FIRAuth.auth()?.currentUser {
//                    let name = user.displayName
//                    let email = user.email
//                    let photoUrl = user.photoURL
//                    let uid = user.uid;  // The user's ID, unique to the Firebase project.
//                    // Do NOT use this value to authenticate with
//                    // your backend server, if you have one. Use
//                    // getTokenWithCompletion:completion: instead.
//                } else {
//                    // No user is signed in.
//                }
                
                
            } else {
                
                // No user is signed in.
                print("user is NOT signed in")
                self.userLoginStatusLabel.text = ""
                self.usernameLabel.text = ""
                self.logoutButton.hidden = true
                self.loginButton.hidden = false
                self.emailTextField.hidden = false
                self.passwordTextField.hidden = false
                self.loginMessageLabel.hidden = true
                self.addPostButton.hidden = true
                self.allPostButton.hidden = true
                self.myPostButton.hidden = true
                prefs.setValue("", forKey: "userID")
                self.profileImageView.hidden = true
                self.updateProfileButton.hidden = true


                
            }
        }
        
    }
    
    
    
    


}
