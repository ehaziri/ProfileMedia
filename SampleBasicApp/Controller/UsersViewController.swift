//
//  UsersViewController.swift
//  SampleBasicApp
//
//  Created by Xona on 10/7/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Show all the users stored in firebase, their profile image, name and age; search users based on first or last name
 */
import UIKit

class UsersViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []
    var searchResults: [User] = []
    var searchController: UISearchController!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.color = UIColor(red: 234, green: 168, blue: 80)
        //Position Activity Indicator in the center of the main view
        activityIndicator.center = view.center
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        activityIndicator.hidesWhenStopped = true
        // Start Activity Indicator
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        //Delegation
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        /*
         Get all the users from the database
        */
        FIRFirestoreService.shared.readAll(from: .users, returning: User.self) { (users) in
            self.users = users
            self.tableView.reloadData()
            activityIndicator.stopAnimating()
        }
        
        // Adding a search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search users..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        
        tableView.tableHeaderView = searchController.searchBar
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //UITableViewDataSource Protocol
    
    //Set number of sections in tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorStyle = .singleLine
        return 1
    }
    //Set the number of rows dynamically based on the activeness of searchController
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return users.count
        }
    }
    //Setup the Cell and fill it with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        
        // Determine if we get the user from search result or the original array.
        let user = (searchController.isActive) ? searchResults[indexPath.row] : users[indexPath.row]
        
        // Configure the cell...
        cell.firstNameLbl.text = user.FirstName
        //Check if there is a URL in the current user's pictureURL field, if yes: get the URL and retrieve the image; put the image as a profile image for the current user.
        if let userImageURL = user.pictureURL, userImageURL != ""{
            let url = URL(string: userImageURL)
            let data = try? Data(contentsOf: url!)
            let img: UIImage = UIImage(data: data!)!
            cell.thumbnailImageView.image = img
        }
        //If not: put a default image as a profile image for the current user.
        else if user.pictureURL == ""{
            cell.thumbnailImageView.image = UIImage(named: "head")
        }
        cell.lastNameLbl.text = user.LastName
        
        let dateOfBirth = DateHelper.shared.getDate(actualDate: user.DateOfBirth)
        let age = DateHelper.shared.getAge(dateOfBirth: dateOfBirth)
   
        cell.ageLbl.text = "\(age) yrs"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    //Helper methods for search field

    func filterContent(for searchText: String) {
        searchResults = users.filter({ (user) -> Bool in
            if let firstName = user.FirstName, let lastName = user.LastName{
                let isMatch = firstName.localizedCaseInsensitiveContains(searchText) || lastName.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    //Dismiss
    @IBAction func backToProfile(_ sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func photosUploaded(_ sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNextView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
}
