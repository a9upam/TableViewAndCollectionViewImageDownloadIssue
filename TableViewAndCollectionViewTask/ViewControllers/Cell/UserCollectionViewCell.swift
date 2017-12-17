//
//  UserCollectionViewCell.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 17/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userProfileDetailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        profileCollectionView.delegate = self
//        profileCollectionView.dataSource = self
        userProfileDetailImageView.layer.cornerRadius = 2.5
        userProfileDetailImageView.clipsToBounds = true
        userProfileDetailImageView.layer.borderColor = UIColor.darkGray.cgColor
        userProfileDetailImageView.layer.borderWidth = 1.6
        // Initialization code
    }

}
