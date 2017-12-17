//
//  UserCollectionViewController.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 17/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit
let urlString1 = "http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=10"


class UserCollectionViewController: UIViewController {
@IBOutlet weak var userTableView: UITableView!
    var serverResponse : ServerResponse?
    let kLazyLoadPlaceholderImage = UIImage(named: "charizard.png")!
    private let refreshControl = UIRefreshControl()

        override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.refreshControl = refreshControl
         refreshControl.addTarget(self, action: #selector(webHitAndReload), for: .valueChanged)
            userTableView.register(UINib(nibName: "UserCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCollectionTableViewCell")
       webHitAndReload()
    }
    @objc func webHitAndReload(){
        serverResponse = nil
        unowned let weakSelf = self
        ServerCommunication.sharedInstance.userListFromUrl(getUrlString: urlString1, postUrlString: nil, success: { (data) in
            weakSelf.getServerResponseOnSuccess(successData: data)
            weakSelf.refreshControl.endRefreshing()
        }) { (responsString) in
            weakSelf.getServerResponseOnFailure(failureResponseString: responsString as String)
        }
    }
    private func getServerResponseOnSuccess (successData : Data){
        do {
            try serverResponse = JSONDecoder().decode(ServerResponse.self, from: successData)
        } catch let er {
            showAlert(title: "Info", message: er.localizedDescription)
        }
        userTableView.reloadData()
    }
    private func getServerResponseOnFailure (failureResponseString : String){
        showAlert(title: "Info", message: failureResponseString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UserCollectionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverResponse?.data?.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = serverResponse?.data?.users![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCollectionTableViewCell", for: indexPath) as! UserCollectionTableViewCell
        cell.userModelFromController = user
        updateImageForCell(cell, inTableView: tableView, withImageURL: (user?.image!)!, atIndexPath: indexPath)
        return cell
    }
    
    func updateImageForCell(_ cell: UITableViewCell, inTableView tableView: UITableView, withImageURL: String, atIndexPath indexPath: IndexPath) {
        unowned let userCell = cell as! UserCollectionTableViewCell
        let user = serverResponse?.data?.users![indexPath.row]
        userCell.userProfileImageView.image = kLazyLoadPlaceholderImage
        userCell.userNameLabel.text = user?.name
        ImageManager.sharedInstance.downloadImageFromURL((user?.image!)!) { (success, image) -> Void in
            if success && image != nil {
                if (tableView.indexPath(for: cell) as NSIndexPath?)?.row == (indexPath as NSIndexPath).row {
                    userCell.userProfileImageView.image = image
                }
            }
        }
    }
    func loadImagesForOnscreenRows() {
        //        if texts.count > 0 {
        let visiblePaths = userTableView.indexPathsForVisibleRows ?? [IndexPath]()
        for indexPath in visiblePaths {
            //                let entry = images[(indexPath as NSIndexPath).row]
//            let user = userArray![indexPath.row]
            let user = serverResponse?.data?.users![indexPath.row]
            let entry = user?.image
            let cell = tableView(userTableView, cellForRowAt: indexPath)
            updateImageForCell(cell, inTableView: userTableView, withImageURL: entry!, atIndexPath: indexPath)
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
