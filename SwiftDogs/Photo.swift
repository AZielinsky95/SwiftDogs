//
//  Photo.swift
//  SwiftDogs
//
//  Created by Alejandro Zielinsky on 2018-04-29.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class Photo: NSObject
{
    var image:UIImage?
    let photoName:String
    //let flickrURL:String
    let photoURL:String
    let id: String
    let farmID:Int
    let serverID:String
    let secret:String
    
    init(dict: [String: Any])
    {
        id = (dict["id"] as? String)!
        photoName = (dict["title"] as? String)!
        farmID = (dict["farm"] as? Int)!
        serverID = (dict["server"] as? String)!
        secret = (dict["secret"] as? String)!
        image = nil;
        photoURL = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
    }
}
