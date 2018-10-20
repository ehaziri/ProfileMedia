//
//  BuildProfileViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/7/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Get user's personal information and register to firebase
 */
import UIKit
import FirebaseAuth

class BuildProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var firstnameLbl: UITextField!
    @IBOutlet weak var lastnameLbl: UITextField!
    @IBOutlet weak var stateLbl: UITextField!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var countryLbl: UITextField!
    @IBOutlet weak var dateofbirthLbl: UITextField!
    var datepic = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates
        firstnameLbl.delegate = self
        lastnameLbl.delegate = self
        stateLbl.delegate = self
        addressLbl.delegate = self
        countryLbl.delegate = self
        dateofbirthLbl.delegate = self
        
        //Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
        if let customFont = UIFont(name: "Helvetica", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 100, blue: 80), NSAttributedString.Key.font: customFont ]
        }
        
        //Set the welcoming message
        username.text = "Welcome \(String(describing: Auth.auth().currentUser!.displayName!))!"
        //Set the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(btnEnter))
        toolbar.setItems([doneBtn], animated: false)
        datepic.datePickerMode = .date
        dateofbirthLbl.inputAccessoryView = toolbar
        dateofbirthLbl.inputView = datepic

        // Do any additional setup after loading the view.
    }
    @IBAction func continueBtn(_ sender: UIButton) {
        if validateInputs(){
            let currentUser = Auth.auth().currentUser!.uid
            print("Session: \(currentUser)")
            let user = User(FirstName: firstnameLbl.text!, LastName: lastnameLbl.text!, Address: addressLbl.text!, State: stateLbl.text!, Country: countryLbl.text!, DateOfBirth: dateofbirthLbl.text!, pictureURL: "")
    
            /*
             Store the user information to the database
            */
            FIRFirestoreService.shared.create(for: user, in: .users, to: currentUser)
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            print("Errors in BuildProfileViewController.")
            return
        }
    }
    //Validate user inputs
    func validateInputs() -> Bool{
        guard firstnameLbl.text != "" else {
            alertBox(errorMessage: "first name")
            return false
        }
        guard lastnameLbl.text != "" else {
            alertBox(errorMessage: "last name")
            return false
        }
        guard addressLbl.text != "" else {
            alertBox(errorMessage: "address")
            return false
        }
        guard stateLbl.text != "" else {
            alertBox(errorMessage: "state")
            return false
        }
        guard countryLbl.text != "" else {
            alertBox(errorMessage: "country")
            return false
        }
        guard dateofbirthLbl.text != "" else {
            alertBox(errorMessage: "date of birth")
            return false
        }
        return true
    }
    //Pop up an alert notification based on the error message taken
    func alertBox(errorMessage: String){
        let alert = UIAlertController(title: "Something wrong!", message: "Check your \(errorMessage)!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //Dismiss KEYBOARD when the user touches anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //When user tapps RETURN button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameLbl{
            lastnameLbl.becomeFirstResponder()
        }
        else if textField == lastnameLbl{
            addressLbl.becomeFirstResponder()
        }
        else if textField == addressLbl{
            stateLbl.becomeFirstResponder()
        }
        else if textField == stateLbl{
            countryLbl.becomeFirstResponder()
        }
        else if textField == countryLbl{
            dateofbirthLbl.becomeFirstResponder()
        }
        else if textField == dateofbirthLbl{
            textField.resignFirstResponder()
        }
        return true
    }
    
    //For UIPicker
    @objc func btnEnter(){
        self.dateofbirthLbl.text = "\(datepic.date)"
        self.view.endEditing(true)
    }

}
