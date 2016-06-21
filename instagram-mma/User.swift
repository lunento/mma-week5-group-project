//
//  User.swift
//  ProjectOCCoreData
//
//  Created by Pasha Bahadori on 6/20/16.
//  Copyright © 2016 Pelican Inc. All rights reserved.
//
import UIKit

class User: NSObject {
    let name: String?
    let avatar: UIImageView
    let post: UIImageView
    let likes: String?
    let comments: String?
    
    
    init(withName name: String, avatar: UIImageView, post: UIImageView, likes: String?, comments: String?) {
        self.name = name
        self.avatar = avatar
        self.post = post
        self.likes = likes
        self.comments = comments
    }
}