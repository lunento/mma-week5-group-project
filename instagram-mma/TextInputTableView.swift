//
//  TextInputTableView.swift
//  instagram-mma
//
//  Created by Ernie on 6/17/16.
//  Copyright © 2016 Ernie. All rights reserved.
//

import UIKit

public class TextInputTableView: UITableViewCell {
    
    @IBOutlet weak var myTextField: UITextField!
    
    public func configure(text: String?, placeholder: String?) {
        
        myTextField.text = text
        myTextField.placeholder = placeholder
        
    }
    
}

