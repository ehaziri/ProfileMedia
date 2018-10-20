//
//  SnapshotExtensions.swift
//  MyApp
//
//  Created by Xona on 10/4/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Important and useful way to decode data sent to database
 */
import Foundation
import FirebaseFirestore

extension DocumentSnapshot{
    //Include a value for property excluded in toJson-Encodable, be aware of all the properties in Model that were excluded.
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        var documentJson = data()
        if includingId {
            documentJson!["id"] = documentID
        }
        let documentData = try JSONSerialization.data(withJSONObject: documentJson!, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
