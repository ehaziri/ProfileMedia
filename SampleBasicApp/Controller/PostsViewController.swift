//
//  PostsViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/3/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Show all the posts of the current user logged in and set the primary image on the list as a profile image for user - if it isn't set one (as requested)jjj
 */
import UIKit
import FirebaseAuth

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post](){
        didSet{
            setFirstImageAsProfilePic()
        }
    }
    var users = [User]()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegation
        tableView.delegate = self
        tableView.dataSource = self
        //Set the height of row
        tableView.rowHeight = 300
        
        /*
         Retrieve from the database all the user's media uploaded
         */
        FIRFirestoreService.shared.read(from: .media, returning: Post.self, specificField: "owner") { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    /*
     Retrieve from the database information for current user logged in, in order to check wheather he has a profile image URL.
     */
    func setFirstImageAsProfilePic(){
        FIRFirestoreService.shared.readDocument(from: .users, returning: User.self, specificDocument: (Auth.auth().currentUser?.uid)!, completion: { (user) in
            self.user = user
            /*
             Set the primary media uploaded as a profile picture for the logged user; if there is at least one image and if user has no profile image already.
             */
            if self.user.pictureURL == "" && self.posts.count > 0 {
                self.user.pictureURL = self.posts[0].imageDownloadURL
                FIRFirestoreService.shared.update(for: self.user, in: .users, specificDocument: Auth.auth().currentUser!.uid)
            }
        })
    }
    
    //Manage the rows of the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    //Manage the rows of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        cell.postTitle.text = posts[indexPath.row].title
        //Retrieve the image using url
        let postUrl = posts[indexPath.row].imageDownloadURL
        let url = URL(string: postUrl!)
        let data = try? Data(contentsOf: url!)
        
        let postImg: UIImage = UIImage(data: data!)!
        
        cell.postImg.image = postImg
        return cell
    }
    //Dismiss view
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
