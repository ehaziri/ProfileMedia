//
//  RegisterViewController.swift
//  MyApp
//
//  Created by Xona on 10/3/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
    Register account
 */
import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var confirmPasswordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates to emailInput and passwordInput
        usernameInput.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
        confirmPasswordInput.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //Validate user inputs and register user to Firebase
    @IBAction func registerAccount(_ sender: UIButton) {
        guard let email = emailInput.text, email != "" else {
            alertBox(errorMessage: "Check your email!")
            return
        }
        guard let password = passwordInput.text, password != "" else {
            alertBox(errorMessage: "Check your password!")
            return
        }
        guard let username = usernameInput.text, username != "" else {
            alertBox(errorMessage: "Check your username!")
            return
        }
        if passwordInput.text != confirmPasswordInput.text{
            alertBox(errorMessage: "Check your confirmed password!")
            return
        }
        
        //Register account to firebase
        Auth.auth().createUser(withEmail: email, password: password){ user, error in
            if error == nil && user != nil {
                print("User created here! \(String(describing: user))")
                //Save the name of the user
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { error in
                    if error == nil{
                        print("Display name: \(String(describing: Auth.auth().currentUser?.displayName))")
                        //self.dismiss(animated: false, completion: nil)
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BuildProfile") {
                            UIApplication.shared.keyWindow?.rootViewController = viewController
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
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
        if textField == usernameInput{
            emailInput.becomeFirstResponder()
        }
        else if textField == emailInput{
            passwordInput.becomeFirstResponder()
        }
        else if textField == passwordInput{
            confirmPasswordInput.becomeFirstResponder()
        }
        else if textField == confirmPasswordInput{
            textField.resignFirstResponder()
        }
        return true
    }
}
