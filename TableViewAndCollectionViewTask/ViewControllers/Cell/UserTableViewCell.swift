//
//  UserTableViewCell.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 17/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImageView.layer.cornerRadius = 4.5
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.borderColor = UIColor.darkGray.cgColor
        userProfileImageView.layer.borderWidth = 2.6
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
