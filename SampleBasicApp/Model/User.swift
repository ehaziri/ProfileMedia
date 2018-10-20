//
//  User.swift
//  MyApp
//
//  Created by Xona on 10/4/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 User properties specified, attention to the id: it is excluded when data is encoded to json
 */
import Foundation

protocol Identifiable {
    var id: String? { get set }
}

struct User: Codable, Identifiable{
    var id: String? = nil
    var FirstName: String?
    var LastName: String?
    var Address: String
    var State: String
    var Country: String
    var DateOfBirth: String
    var pictureURL: String? = nil
    
    init(FirstName: String?, LastName: String?, Address: String, State: String, Country: String, DateOfBirth: String, pictureURL: String){
        self.FirstName = FirstName
        self.LastName = LastName
        self.Address = Address
        self.State = State
        self.Country = Country
        self.DateOfBirth = DateOfBirth
        self.pictureURL = pictureURL
    }
}
