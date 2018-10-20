//
//  EncodableExtensions.swift
//  MyApp
//
//  Created by Xona on 10/4/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Important and useful way to encode data sent to database
 */
import Foundation
//Any specific error to show up
enum MyError: Error{
    case encodingError
}
extension Encodable{
    //Exclude any property of the Model that you don't want to store in a specific document 
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any]{
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw MyError.encodingError}
        
        for key in keys{
            json[key] = nil
        }
        
        return json
    }
}
