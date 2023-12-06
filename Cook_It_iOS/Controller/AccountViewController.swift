//
//  AccountViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 28/11/23.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let recipeService = RecipeServiceManager()
    
    @IBOutlet var recipeTableView: UITableView!
    @IBOutlet var newRecipeButton: UIButton!
    @IBOutlet var friendsButton: UIButton!
    @IBOutlet var favouritesButton: UIButton!
    @IBOutlet var addFriendButton: UIButton!
    @IBOutlet var removeFriendButton: UIButton!
    @IBOutlet var userImage: UIImageView!
    
    var isLocalUser = true
    var userOwnID: String = ""
    var userOwnImage: String = ""
    var userOwnRecipes: [String] = []
    private var tmpUserRecipes: [RecipeDto] = []
    private var tmpLocalRecipes: [RecipeEntity] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        
        if isLocalUser {
            recipeTableView.reloadData()
            newRecipeButton.isHidden = false
            friendsButton.isHidden = false
            favouritesButton.isHidden = false
            addFriendButton.isHidden = true
            removeFriendButton.isHidden = true
        } else {
            newRecipeButton.isHidden = true
            friendsButton.isHidden = true
            favouritesButton.isHidden = true
            addFriendButton.isHidden = false
            removeFriendButton.isHidden = false
            userImage.sd_setImage(with: URL(string: userOwnImage))
            userImage.layer.cornerRadius = 20.0
            
            recipeService.getRecipes() { recipes in
                recipes.forEach() { recipe in
                    if self.userOwnRecipes.contains(recipe.recipe_id){
                        print("se agrega la receta: ",recipe.title," con id: ",recipe.recipe_id)
                        self.tmpUserRecipes.append(recipe)
                    }
                }
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLocalUser {
            let recipeManager = RecipeEntityManager(context: context)
            tmpLocalRecipes = recipeManager.getAllRecipes()
            recipeTableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLocalUser {
            let recipeManager = RecipeEntityManager(context: context)
//            return recipeManager.getAllRecipes().count
            return tmpLocalRecipes.count
        } else {
            return tmpUserRecipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLocalUser {
            let recipeManager = RecipeEntityManager(context: context)
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
            
//            cell.recipeTitle.text = recipeManager.getAllRecipes()[indexPath.row].title
            cell.recipeTitle.text = tmpLocalRecipes[indexPath.row].title
            cell.recipeImage.image = UIImage(named: "cookitlogo")
            
            return cell
        } else {
            if indexPath.row > tmpUserRecipes.count {
                return UITableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
                
                cell.recipeImage.sd_setImage(with: URL(string: tmpUserRecipes[indexPath.row].img ?? ""))
                cell.recipeTitle.text = tmpUserRecipes[indexPath.row].title
                cell.layer.cornerRadius = 30.0
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "localRecipeDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeManager = RecipeEntityManager(context: context)
        
        if segue.identifier == "localRecipeDetail" {
            let destination = segue.destination as! RecipeDetailViewController
            
            destination.id = String(recipeManager.getAllRecipes()[recipeTableView.indexPathForSelectedRow!.row].recipe_id)
            destination.segueName = "localRecipeDetail"
        }
    }
    
    @IBAction func addFriendAction(_ sender: Any) {
        let friendManager = FriendEntityManager(context: context)
        if friendManager.getFriend(id: userOwnID) == nil {
            let friendTmp = FriendEntity(context: context)
            friendTmp.friendId = userOwnID
            friendManager.createFriend(friendId: friendTmp)
        }
    }
    
    @IBAction func deleteFriendAction(_ sender: Any) {
        print("click en borrar")
        let friendManager = FriendEntityManager(context: context)
        if let friendTmp = friendManager.getFriend(id: userOwnID){
            friendManager.deleteFriend(friend: friendTmp)
        } else {
            print("No se pudo eliminar amigo")
        }
        
    }
}
