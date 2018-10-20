//
//  ChooseNextViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/8/18.
//  Copyright © 2018 Xona. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChooseNextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goProfile(_ sender: UIButton) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
