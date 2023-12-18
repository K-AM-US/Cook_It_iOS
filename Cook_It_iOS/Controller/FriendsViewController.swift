//
//  FriendsViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 04/12/23.
//

import UIKit
import Firebase
import FirebaseAuth

class FriendsViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchFriendTable: UITableView!
    
    let userServiceManager = UserServiceManager()
    private var users: [UserDto] = []
    private var friends: [UserDto] = []
    private var filteredFriends: [UserDto] = []
    
    private let emptyMessage: UILabel = {
        let label = UILabel()
        label.text = "Está muy solo por aquí,\nañade un amigo."
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let friendManager = FriendEntityManager(context: context)
        
        searchFriendTable.dataSource = self
        searchFriendTable.delegate = self
        
        searchBar.delegate = self
        
        userServiceManager.getUsers() { users in
            self.users = users
            users.forEach() { user in
                if friendManager.getFriend(friendId: user.id, userId: Auth.auth().currentUser!.uid) != nil {
                    self.friends.append(user)
                }
            }
            
            self.filteredFriends = self.friends
            DispatchQueue.main.async {
                self.searchFriendTable.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filteredFriends = friends
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredFriends.count == 0 {
            emptyMessage.isHidden = false
            view.addSubview(emptyMessage)
            emptyMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emptyMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        } else {
            emptyMessage.isHidden = true
        }
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
            
            let indexPath = searchFriendTable.indexPathForSelectedRow
            let row = indexPath?.row
        
            destination.isLocalUser = false
            destination.userOwnID = filteredFriends[row!].id
            destination.userOwnImage = filteredFriends[row!].image
            destination.userOwnRecipes = filteredFriends[row!].recipes
            destination.usernameOwn = filteredFriends[row!].username
            destination.userOwnFullName = filteredFriends[row!].first_name + " " + filteredFriends[row!].last_name
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
