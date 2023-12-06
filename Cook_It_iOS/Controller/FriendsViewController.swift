//
//  FriendsViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 04/12/23.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchFriendTable: UITableView!
    
    let userServiceManager = UserServiceManager()
    private var users: [UserDto] = []
    private var friends: [UserDto] = []
    private var filteredFriends: [UserDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let friendManager = FriendEntityManager(context: context)
        print(friendManager.getAllFriends())
        searchFriendTable.dataSource = self
        searchFriendTable.delegate = self
        
        searchBar.delegate = self
        
        userServiceManager.getUsers() { users in
            self.users = users
            users.forEach() { user in
                if friendManager.getFriend(id: user.id) != nil {
                    self.friends.append(user)
                }
            }
            self.filteredFriends = self.friends
            DispatchQueue.main.async {
                self.searchFriendTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > filteredFriends.count {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
            
            let friend = filteredFriends[indexPath.row]
            
            cell.userImage.sd_setImage(with: URL(string: friend.image))
            cell.userImage.layer.cornerRadius = 30.0
            cell.username.text = friend.username
            cell.fullName.text = friend.first_name + " " + friend.last_name
            
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
            destination.userOwnID = userServiceManager.getUser(at: searchFriendTable.indexPathForSelectedRow!.row).id
            destination.userOwnImage = userServiceManager.getUser(at: searchFriendTable.indexPathForSelectedRow!.row).image
            destination.userOwnRecipes = userServiceManager.getUser(at: searchFriendTable.indexPathForSelectedRow!.row).recipes
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredFriends = []
        friends.forEach() { friend in
            if friend.username.lowercased().contains(searchText.lowercased()) || friend.first_name.lowercased().contains(searchText.lowercased()) || friend.last_name.lowercased().contains(searchText.lowercased()){
                filteredFriends.append(friend)
            }
            if searchText == "" {
                filteredFriends = friends
            }
        }
        self.searchFriendTable.reloadData()
    }
}
