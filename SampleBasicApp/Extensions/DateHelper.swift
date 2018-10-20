//
//  Date.swift
//  SampleBasicApp
//
//  Created by Xona on 10/8/18.
//  Copyright © 2018 Xona. All rights reserved.
//

import Foundation

class DateHelper{
    
    public static let shared = DateHelper()
    //Convert String to Date
    func getDate(actualDate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss Z"
        return dateFormatter.date(from: actualDate)! // replace Date String
        
    }
    //Get age of the user, and return is as a String for display
    func getAge(dateOfBirth: Date) -> String{
        let calendar = Calendar.current
        let year = Int(calendar.component(.year, from: dateOfBirth))
        let age = 2018 - year
        return String(age)
    }
}
