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
    
    let buttonReload: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recargar", for: .normal)
        button.tintColor = UIColor(named: "blueCookIt")
        button.configuration = .filled()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let networkMessage: UILabel = {
        let label = UILabel()
        label.text = "Ocurrió un error,\n intenta otra vez"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let progressBar: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.style = .large
        progress.color = UIColor(named: "blueCookIt")
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUsersTable.dataSource = self
        searchUsersTable.delegate = self
        
        searchBar.delegate = self
        
        view.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        progressBar.startAnimating()
        progressBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if InternetMonitor.shared.internetStatus {
            buttonReload.isHidden = true
            searchUsersTable.isHidden = false
            searchBar.isHidden = false
            userServiceManager.getUsers { users in
                
                self.users = users
                self.filteredUsers = users
                
                DispatchQueue.main.async {
                    self.searchUsersTable.reloadData()
                    self.progressBar.isHidden = true
                }
            }
        } else {
            progressBar.isHidden = true
            searchUsersTable.isHidden = false
            searchBar.isHidden = false
            buttonReload.isHidden = false
            
            view.addSubview(networkMessage)
            networkMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            networkMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
            
            self.view.addSubview(buttonReload)
            buttonReload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonReload.topAnchor.constraint(equalTo: networkMessage.bottomAnchor, constant: 130).isActive = true
            buttonReload.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
    }
    
    @objc func reload() {
        viewDidAppear(true)
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
            
            let indexPath = searchUsersTable.indexPathForSelectedRow
            let row = indexPath?.row
            
            destination.isLocalUser = false
            destination.userOwnID = filteredUsers[row!].id
            destination.usernameOwn = filteredUsers[row!].username
            destination.userOwnFullName = filteredUsers[row!].first_name + " " + filteredUsers[row!].last_name
            destination.userOwnImage = filteredUsers[row!].image
            destination.userOwnRecipes = filteredUsers[row!].recipes
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
