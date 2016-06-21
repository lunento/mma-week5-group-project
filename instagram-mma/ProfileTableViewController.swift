//
//  ProfileTableViewController.swift
//  instagram-mma
//
//  Created by Ernie on 6/17/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileTableViewController: UITableViewController {

    var about = ["Gender", "Age", "Phone", "Email", "Website", "Bio"]
    var ref = FIRDatabase.database().reference()
    
    // this will get the CURRENT USER
    var user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
//        print("about.count = \(about.count)")
        
        var refHandle = ref.child("user").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let usersDictionary = snapshot.value as! NSDictionary
            print(usersDictionary)
            
            let userDetails = usersDictionary.objectForKey(self.user!.uid)
            
            // now we need to get the data and populate the fields with any data from the DB
            
            var index = 0
            
            while index<self.about.count{
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                let cell:TextInputTableView? = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableView?
                
                let field: String = (cell?.myTextField.placeholder?.lowercaseString)!
                
                switch field {
                case "gender":
                    cell?.configure(userDetails?.objectForKey("gender") as? String, placeholder: "Gender")
                case "age":
                    cell?.configure(userDetails?.objectForKey("age") as? String, placeholder: "Age")
                case "phone":
                    cell?.configure(userDetails?.objectForKey("phone") as? String, placeholder: "Phone")
                case "email":
                    cell?.configure(userDetails?.objectForKey("email") as? String, placeholder: "Email")
                case "website":
                    cell?.configure(userDetails?.objectForKey("website") as? String, placeholder: "Website")
                case "bio":
                    cell?.configure(userDetails?.objectForKey("bio") as? String, placeholder: "Bio")
                default:
                    ""
                }
                
                index+=1
            }
            
            
        })
    }
    
    
    

    
    @IBAction func didTapUpdate(sender: AnyObject) {
        
        print("didTapUpdate button")
        
        var index = 0
        
        while index<about.count{
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell: TextInputTableView? = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableView
            
            if cell?.myTextField.text != ""{
                
                let item:String = (cell?.myTextField.text!)!
                
                switch about[index]{
                    case "Gender":
                        self.ref.child("user").child("\(user!.uid)/profile/gender").setValue(item)
                    case "Age":
                        self.ref.child("user").child("\(user!.uid)/profile/age").setValue(item)
                    case "Phone":
                        self.ref.child("user").child("\(user!.uid)/profile/phone").setValue(item)
                    case "Email":
                        self.ref.child("user").child("\(user!.uid)/profile/email").setValue(item)
                    case "Website":
                        self.ref.child("user").child("\(user!.uid)/profile/website").setValue(item)
                    case "Bio":
                        self.ref.child("user").child("\(user!.uid)/profile/bio").setValue(item)
                default:
                    print("Dont update")
                    
                } // end switch
        } // end if
            
            index+=1
            cell?.myTextField.resignFirstResponder()
        
    }
    
}
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TextInputTableView = tableView.dequeueReusableCellWithIdentifier("TextInput", forIndexPath: indexPath) as! TextInputTableView
        
        cell.configure("", placeholder: "\(about[indexPath.row])")

        
        
        return cell
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
