//
//  SearchUsersViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 13/11/23.
//

import UIKit

class SearchUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
        
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchUsersTable: UITableView!
    
    let userServiceManager = UserServiceManager()
    private var users: [UserDto] = []
    private var filteredUsers: [UserDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUsersTable.dataSource = self
        searchUsersTable.delegate = self
        
        searchBar.delegate = self

        userServiceManager.getUsers { users in
            
            self.users = users
            self.filteredUsers = users
            
            DispatchQueue.main.async {
                self.searchUsersTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > filteredUsers.count {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
            
            let user = filteredUsers[indexPath.row]
            cell.userImage.sd_setImage(with: URL(string: user.image))
            cell.userImage.layer.cornerRadius = 30.0
            cell.username.text = user.username
            cell.fullName.text = user.first_name + " " + user.last_name
            
            cell.layer.cornerRadius = 30.0
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "userDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetail" {
            let destination = segue.destination as! AccountViewController
            
            destination.isLocalUser = false
            destination.userOwnID = userServiceManager.getUser(at: searchUsersTable.indexPathForSelectedRow!.row).id
            destination.userOwnImage = userServiceManager.getUser(at: searchUsersTable.indexPathForSelectedRow!.row).image
            destination.userOwnRecipes = userServiceManager.getUser(at: searchUsersTable.indexPathForSelectedRow!.row).recipes
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = []
        users.forEach() { user in
            if user.username.lowercased().contains(searchText.lowercased()) ||
               user.first_name.lowercased().contains(searchText.lowercased()) ||
               user.first_name.lowercased().contains(searchText.lowercased()) {
                filteredUsers.append(user)
            }
            if searchText == "" {
                filteredUsers = users
            }
        }
        self.searchUsersTable.reloadData()
    }
}
