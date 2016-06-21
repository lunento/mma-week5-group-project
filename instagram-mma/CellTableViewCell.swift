//
//  CellTableViewCell.swift
//  newsFeedIG
//
//  Created by Pasha Bahadori on 6/20/16.
//  Copyright © 2016 Pelican Inc. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var comments: UILabel!
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let emiliaPic = "Emilia2.jpg"
//        let emiliaImage = UIImage(named: emiliaPic)
        
//        let sandra = User(withName: "DandySanddyyyy", avatar:UIImageView(image: sandraImage!), post: UIImageView(image: sandraImage!), likes: "120", comments: "omggg sandy will u marry meeee")
//        sandra.post.image = postImage.image
        
//        postImage.image = emiliaImage
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
