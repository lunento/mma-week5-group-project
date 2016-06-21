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
                self.login()
                
            }
        
        }
        
    }
    
    func logout() {
        try! FIRAuth.auth()!.signOut()
        isUserLoggedIn()
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
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
                print("YEAH! LOGGED IN OK")
                self.loginMessageLabel.hidden = false
                self.loginMessageLabel.text = "You're Logged In!"
                self.loginMessageLabel.backgroundColor = UIColor.greenColor()
                self.addPostButton.hidden = false
                self.allPostButton.hidden = false
                self.myPostButton.hidden = false
                prefs.setValue("\(user!.uid)", forKey: "userID")
            }
        })
        
        
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
                
                if let user = FIRAuth.auth()?.currentUser {
                    // User is signed in.
                    // display currentUser name
                    self.usernameLabel.text = "currentUser: \(user)\nEmail: \(user.email!)\nUID: \(user.uid)\nDisplayName: \(user.displayName)"

                } else {
                    
                    // No user is signed in.
                    self.usernameLabel.text = ""
                    self.logoutButton.hidden = true
                    self.loginButton.hidden = false
                }
                
                if let user = FIRAuth.auth()?.currentUser {
                    let name = user.displayName
                    let email = user.email
                    let photoUrl = user.photoURL
                    let uid = user.uid;  // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with
                    // your backend server, if you have one. Use
                    // getTokenWithCompletion:completion: instead.
                } else {
                    // No user is signed in.
                }
                
                
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


                
            }
        }
        
    }
    
    
    
    


}
