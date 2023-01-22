//
//  UsersTableViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-08.
//

import UIKit

class UsersTableViewController: UITableViewController {

    
    var allUsers:[User] = []
    var filteredUser:[User] = []
    
   
    let searchContollers = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
       downloadUser()
        setupsearchcontroller()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILE") as! ProfileTableViewController
        
        let usertosend = searchContollers.isActive ? filteredUser[indexPath.row] : allUsers[indexPath.row]
        story.user = usertosend
        self.navigationController?.pushViewController(story, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchContollers.isActive ? filteredUser.count : allUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! USERSTableViewCell
        
        let users = searchContollers.isActive ? filteredUser[indexPath.row] : allUsers[indexPath.row]
        cell.configureUser(user: users)
        
        return cell
    }
    
    
    func downloadUser()
    {
        firebaseuserListener.shared.downloadAllUserFromFirebase { allUsers in
            print("called")
            self.allUsers = allUsers!
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func setupsearchcontroller()
    {
        navigationItem.searchController = searchContollers
        navigationItem.hidesSearchBarWhenScrolling = true
        searchContollers.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchContollers.searchResultsUpdater = self
    }
    
    func filter(searchString:String){
        filteredUser = allUsers.filter { user -> Bool in
            return user.username.lowercased().contains(searchString.lowercased())
        }
        self.tableView.reloadData()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if((self.refreshControl!.isRefreshing))
        {
            self.downloadUser()
            self.refreshControl?.endRefreshing()
        }
    }
}

extension UsersTableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filter(searchString: searchController.searchBar.text!)
    }
    
    
}
