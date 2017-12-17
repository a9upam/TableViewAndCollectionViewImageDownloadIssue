
//
//  ServerResponseModel.swift
//  TableViewAndCollectionViewTask
//
//  Created by Anupam G on 17/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class ServerResponseModel: NSObject {

}

struct ServerResponse : Decodable {
    var status : Bool?
    var message : String?
    var data : ResponseDataModel?
}
struct ResponseDataModel : Decodable {
    var users : [User]?
    var has_more : Bool?
}
struct User : Decodable {
    var name : String?
    var image : String?
    var items : [String]?
}
