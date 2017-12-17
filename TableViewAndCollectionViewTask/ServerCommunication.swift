//
//  ServerCommunication.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 16/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class ServerCommunication: NSObject {
    
    static let sharedInstance = ServerCommunication()
    func userListFromUrl (getUrlString : String?, postUrlString : String?, success:@escaping (Data)->Void, failure:@escaping (NSString)->Void) ->Void{
        guard let checkedUrlString = getUrlString  else { return }
//        guard let checkedPostString = postUrlString else { return }
//        let urlString = "http://115.112.118.252/madfly/public/index.php/category"
        let getURL = URL.init(string: urlString)
        let urlRequest = NSMutableURLRequest(url: getURL!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        if(postUrlString != nil){
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"
            guard let checkedString = postUrlString else {
                return
            }
            urlRequest.httpBody = checkedString.data(using: .utf8)
        }else{
            urlRequest.httpMethod = "GET"
        }
        serverHTTPRequesturl(urlRequest: (urlRequest as NSMutableURLRequest) as URLRequest, success: success, failure: failure)
    }
    private func serverHTTPRequesturl(urlRequest : URLRequest, success: @escaping (Data)->Void , failure: @escaping (NSString)->Void)->Void{
        let session = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                //means have some error
                guard let checkedErrorString = error?.localizedDescription else { print ("Eror occured"); return }
                DispatchQueue.main.async(execute: {
                    failure(checkedErrorString as NSString)
                })
            }else{
                guard let checkedServerData = data else {return}
                DispatchQueue.main.async(execute: {
                    success(checkedServerData)
                })
            }
        }
        session.resume()
    }
    private func serverHTTPRequesturl(urlRequest : URLRequest, success: @escaping (Data)->Void , failure: @escaping (Data)->Void)->Void{
        let session = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                //means have some error
                guard let checkedErrorString = error?.localizedDescription else { print ("Eror occured"); return }
                DispatchQueue.main.async(execute: {
//                    failure(checkedErrorString as NSString)
                })
            }else{
                guard let checkedServerData = data else {return}
                DispatchQueue.main.async(execute: {
                    success(checkedServerData)
                })
            }
        }
        session.resume()
    }
}
