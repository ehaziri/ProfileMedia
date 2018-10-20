//
//  ViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/7/18.
//  Copyright © 2018 Xona. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Current user logged in
        if let user = Auth.auth().currentUser{
            print("Current user: \(String(describing: user.displayName!))  \(user.uid)")
        }
    }
}

