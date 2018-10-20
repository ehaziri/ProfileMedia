//
//  Post.swift
//  MyApp
//
//  Created by Xona on 10/4/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Post properties specified
 */
import Foundation
import UIKit

struct Post: Codable{
    var title: String!
    var owner: String!
    var imageDownloadURL: String!
    
    init(title: String, owner: String, imageDownloadURL: String) {
        self.imageDownloadURL = imageDownloadURL
        self.title = title
        self.owner = owner
    }
}
