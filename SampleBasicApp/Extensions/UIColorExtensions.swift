//
//  UIColor.swift
//  MyApp
//
//  Created by Xona on 10/6/18.
//  Copyright © 2018 Xona. All rights reserved.
//

import UIKit
//Helper
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}

