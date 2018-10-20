//
//  MediaUploadViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/8/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Show the image picker and upload the picked image with data to firestore
 */
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class MediaUploadViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var postInput: UITextField!
    @IBOutlet weak var handleGalleryBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    var takenImage: UIImage!
    var newPost:Post?
  
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegate
        postInput.delegate = self
        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photoImageView.image = takenImage
    }
    //Show an alert box for the user to choose Camera or Library, in order to pick an image for uploadment
    @IBAction func galleryBtnPressed(_ sender: UIButton) {
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        //Set camera as a source as an image source
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        //Set the library as an image source
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    //Dismiss view
    @IBAction func cancelPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    /*
     Store the image with its data to the database
    */
    @IBAction func savePressed(_ sender: Any) {
        //check for the presence of image and its title
        if postInput.text != "" && takenImage != nil {
            if let imageData = takenImage.jpeg(.medium){
            //Set a specific path for image storage
             let storage = Storage.storage().reference().child("photos/\(takenImage.hashValue)")
                
                storage.putData(imageData).observe(.success, handler: { (snapshot) in
                    let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                    let nameOfImageStored = snapshot.metadata?.name
                    self.newPost = Post(title: self.postInput.text ?? "no title", owner: (Auth.auth().currentUser?.uid)!, imageDownloadURL: downloadURL!)
                    FIRFirestoreService.shared.create(for: self.newPost, in: .media, to: nameOfImageStored!)
                })
            }
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNextView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        else{
            alertBox(errorMessage: "Please, make sure you filled in the title and selected the image!")
        }
    }
    //Show an alert for the errors
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
        if textField == postInput{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension MediaUploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.takenImage = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
