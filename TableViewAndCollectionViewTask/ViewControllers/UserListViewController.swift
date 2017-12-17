//
//  UserListViewController.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 17/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

let urlString = "http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=100"
//let urlString = "http://115.112.118.252/madfly/public/index.php/category"
let dict = ["userId":"50","dpu":"1"]


class UserListViewController: UIViewController {

    var serverResponse : ServerResponse?
    var userArray : [User]?
     let cache = NSCache<NSString, UIImage>()
    let kLazyLoadPlaceholderImage = UIImage(named: "charizard.png")!
    
    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.register( UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        unowned let weakSelf = self
        ServerCommunication.sharedInstance.userListFromUrl(getUrlString: urlString, postUrlString: nil, success: { (data) in
            weakSelf.getServerResponseOnSuccess(serverResponseData: data)
        }) { (responseMessage) in
            weakSelf.getServerResponseOnFailure(failureResponse: responseMessage as String)
        }
    }
   
 
    private func getServerResponseOnSuccess (serverResponseData : Data){
        do {
            try serverResponse = JSONDecoder().decode(ServerResponse.self, from: serverResponseData)
            userArray = serverResponse?.data?.users
        } catch let error {
            showAlert(title: "Parsing error", message: error.localizedDescription)
        }
        userTableView.reloadData()
    }
    private func getServerResponseOnFailure (failureResponse : String){
        print("Server Response :", failureResponse)
        showAlert(title: "Server Failure", message: failureResponse)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
       let imageCache = NSCache<NSString, UIImage>()
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage, nil)
        } else {
//            guard let checkedImageUrlString = imageUrlString else {
//                return
//            }
//            unowned let weakSelf = self
            let imageURL = URL.init(string: url)
            let session = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
                if error != nil{
                }
                else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url as NSString)
//                    DispatchQueue.main.async(execute: {
                        completion(image, nil)
//                    })

                }
//                else{
//                    DispatchQueue.main.async(execute: {
////                        weakSelf.image = UIImage.init(data: data!)
//                    })
//                }
            }
            session.resume()
            
//            MTAPIClient.downloadData(url: url) { data, response, error in
//                if let error = error {
//                    completion(nil, error)
//
//                } else if let data = data, let image = UIImage(data: data) {
//                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
//                    completion(image, nil)
//                } else {
//                    completion(nil, NSError.generalParsingError(domain: url.absoluteString))
//                }
//            }
        }
    }
}
extension UIViewController {
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })))
        self.present(alert, animated: true, completion: nil)
    }
}
extension UserListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = userArray![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        updateImageForCell(cell, inTableView: tableView, withImageURL: user.image!, atIndexPath: indexPath)
        return cell
    }
    
    func updateImageForCell(_ cell: UITableViewCell, inTableView tableView: UITableView, withImageURL: String, atIndexPath indexPath: IndexPath) {
        unowned let userCell = cell as! UserTableViewCell
        
        userCell.userProfileImageView.image = kLazyLoadPlaceholderImage
         let user = userArray![indexPath.row]
        ImageManager.sharedInstance.downloadImageFromURL(user.image!) { (success, image) -> Void in
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
                let user = userArray![indexPath.row]
                let entry = user.image
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
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let user = userArray![indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
//        cell.userProfileImageView.image = nil
////        cell.userProfileImageView.imageWithUrl(imageUrlString: user.image)
//        unowned let weakSelf = cell
//        UserListViewController.downloadImage(url: user.image!) { (img, er) in
//            if er != nil{
//
//            }else{
//                DispatchQueue.main.async(execute: {
//                  weakSelf.userProfileImageView.image = img
//                })
////                weakSelf.userProfileImageView.image = img
//            }
//        }
//        return cell
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        // 1
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
//         let user = userArray![indexPath.row]
//        let newString: String = String(indexPath.row)
//        if (self.cache.object(forKey: newString as NSString) != nil){
//            print("Cached image used, no need to download it")
//            cell.userProfileImageView?.image = self.cache.object(forKey: newString as NSString)
//        }else{
//            let url:URL! = URL(string: user.image!)
//          let  task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
//                if let data = try? Data(contentsOf: url){
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        if let updateCell = tableView.cellForRow(at: indexPath) {
//                            let myCell = updateCell as! UserTableViewCell
//                            let img:UIImage! = UIImage(data: data)
//                            myCell.userProfileImageView.image = img
//                            self.cache.setObject(img, forKey: (newString as NSString))
//                        }
//                    })
//                }
//            })
//            task.resume()
//        }
//        return cell
//    }

}

extension UIImageView {
    func imageWithUrl (imageUrlString : String?){
        guard let checkedImageUrlString = imageUrlString else {
            return
        }
        unowned let weakSelf = self
        let imageURL = URL.init(string: checkedImageUrlString)
        let session = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            if error != nil{
            }
            else{
                DispatchQueue.main.async(execute: {
                    weakSelf.image = UIImage.init(data: data!)
                })
            }
        }
        session.resume()
    }
}

