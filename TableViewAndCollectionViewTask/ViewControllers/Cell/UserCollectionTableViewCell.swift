//
//  UserCollectionTableViewCell.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 17/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class UserCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
      let kLazyLoadPlaceholderImage = UIImage(named: "charizard.png")!
    var userModelFromController : User? {
        didSet {
            profileCollectionView.reloadData()
        }
//        willSet{
//
//        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        userProfileImageView.layer.cornerRadius = 4.5
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.borderColor = UIColor.darkGray.cgColor
        userProfileImageView.layer.borderWidth = 2.6
        profileCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionViewCell")
        // Initialization code
    }
    private func configureMyCell(){
        userNameLabel.text = userModelFromController?.name
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension UserCollectionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userModelFromController?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = userModelFromController?.items![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        cell.loadingIndicator.startAnimating()
        updateImageForCell(cell, inTableView: collectionView, withImageURL: imageUrlString!, atIndexPath: indexPath)
        return cell
    }
    
    func updateImageForCell(_ cell: UICollectionViewCell, inTableView collectionView: UICollectionView, withImageURL: String, atIndexPath indexPath: IndexPath) {
        unowned let userCell = cell as! UserCollectionViewCell
        userCell.userProfileDetailImageView.image = kLazyLoadPlaceholderImage
         let imageUrlString = userModelFromController?.items![indexPath.row]
//        let user = userArray![indexPath.row]
        ImageManager.sharedInstance.downloadImageFromURL(imageUrlString!) { (success, image) -> Void in
            if success && image != nil {
                if (collectionView.indexPath(for: cell) as NSIndexPath?)?.row == (indexPath as NSIndexPath).row {
                    userCell.userProfileDetailImageView.image = image
                    userCell.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    func loadImagesForOnscreenRows() {
        //        if texts.count > 0 {
        let visiblePaths = profileCollectionView.indexPathsForVisibleItems
        for indexPath in visiblePaths {
            let userImageString = userModelFromController?.items![indexPath.row]
//            let cell = profileCollectionView(collectionView, cellForRowAt: indexPath)
            let cell = collectionView(profileCollectionView, cellForItemAt: indexPath)
            updateImageForCell(cell, inTableView: profileCollectionView, withImageURL: userImageString!, atIndexPath: indexPath)
        }
        //        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenRows()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenRows()
        }
    }
}
