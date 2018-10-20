//
//  LoginViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/4/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Login account
 */
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates to emailInput and passwordInput
        emailInput.delegate = self
        passwordInput.delegate = self
        // Do any additional setup after loading the view.
    }
     //Validate user inputs and sign in user to Firebase
    @IBAction func loginUser(_ sender: UIButton) {
        guard let email = emailInput.text, email != "" else {
            alertBox(errorMessage: "Check your email!")
            return
        }
        guard let password = passwordInput.text, password != "" else {
            alertBox(errorMessage: "Check your password!")
            return
        }
        //Log in user and show the Profile Page
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let user = user{
                print("User: \(user.email!)")
                //self.dismiss(animated: false, completion: nil)
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else{
                self.alertBox(errorMessage: error!.localizedDescription)
            }
        }
    }
    //Pop up an alert notification based on the error message taken
    func alertBox(errorMessage: String){
        let alert = UIAlertController(title: "Something wrong!", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //Dismiss KEYBOARD when the user touches anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //When user tapps RETURN button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailInput{
            passwordInput.becomeFirstResponder()
        }else if textField == passwordInput{
            textField.resignFirstResponder()
        }
        return true
    }
}
