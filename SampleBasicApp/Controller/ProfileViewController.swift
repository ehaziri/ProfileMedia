//
//  ProfileViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/7/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 User's profile page
 */
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController{

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         Retrieve personal information for the current user from the firebase
         */
        FIRFirestoreService.shared.readDocument(from: .users, returning: User.self, specificDocument: (Auth.auth().currentUser?.uid)!) { (user) in
            self.nameLbl.text = "\(user.FirstName ?? "no name") \(user.LastName ?? "no surname")"
            
            let dateOfBirth = DateHelper.shared.getDate(actualDate: user.DateOfBirth)
            let age = DateHelper.shared.getAge(dateOfBirth: dateOfBirth)
            
            self.ageLbl.text = "\(age) years old"
            
            //Check if there is a URL in the current user's pictureURL field, if yes: get the URL and retrieve the image; put the image as a profile image for the current user.
            if let userImageURL = user.pictureURL, userImageURL != ""{
                let url = URL(string: userImageURL)
                let data = try? Data(contentsOf: url!)
                let img: UIImage = UIImage(data: data!)!
                self.profileImg.image = img
            }
        }

        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
        if let customFont = UIFont(name: "Helvetica", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 234, green: 168, blue: 80), NSAttributedString.Key.font: customFont ]
        }
        // Do any additional setup after loading the view.
    }
    //Log out current user
    @IBAction func logOut(_ sender: UIButton){
        try! Auth.auth().signOut()
        print("User logged out!")
        //self.dismiss(animated: true, completion: nil)
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    //Show Users View Controller
    @IBAction func showUsers(_ sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AllUsers") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
}
