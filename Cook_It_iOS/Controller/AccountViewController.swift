//
//  AccountViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 28/11/23.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeCellDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let recipeService = RecipeServiceManager()
    
    @IBOutlet var recipeTableView: UITableView!
    @IBOutlet var newRecipeButton: UIButton!
    @IBOutlet var friendsButton: UIButton!
    @IBOutlet var favouritesButton: UIButton!
    @IBOutlet var addFriendButton: UIButton!
    @IBOutlet var removeFriendButton: UIButton!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var userfullname: UILabel!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var loginMessage: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoImage: UIImageView!
    
    var isLocalUser = true
    var userOwnID: String = ""
    var usernameOwn: String = ""
    var userOwnFullName: String = ""
    var userOwnImage: String = ""
    var userOwnRecipes: [String] = []
    private var tmpUserRecipes: [RecipeDto] = []
    private var tmpLocalRecipes: [RecipeEntity] = []
    
    private let emptyMessage: UILabel = {
        let label = UILabel()
        label.text = "No hay\nrecetas!"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let emptyMessageLocal: UILabel = {
        let label = UILabel()
        label.text = "No hay recetas aquí, \ncrea una!"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .center
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
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        
        addFriendButton.isHidden = true
        removeFriendButton.isHidden = true
        newRecipeButton.isHidden = true
        friendsButton.isHidden = true
        favouritesButton.isHidden = true
        loginMessage.isHidden = true
        logoImage.isHidden = true
        loginButton.isHidden = true
        settingsButton.isHidden = true
        username.isHidden = true
        userfullname.isHidden = true
        userImage.isHidden = true
        emptyMessage.isHidden = true
        emptyMessageLocal.isHidden = true
        
        progressBar.isHidden = false
        view.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        progressBar.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isLocalUser {
            loginMessage.isHidden = true
            loginButton.isHidden = true
            logoImage.isHidden = true
            
            newRecipeButton.isHidden = true
            friendsButton.isHidden = true
            favouritesButton.isHidden = true
            settingsButton.isHidden = true
            addFriendButton.isHidden = false
            removeFriendButton.isHidden = false
            username.isHidden = false
            userfullname.isHidden = false
            userImage.isHidden = false
            emptyMessageLocal.isHidden = true
            
            username.text = usernameOwn
            userfullname.text = userOwnFullName
            userImage.sd_setImage(with: URL(string: userOwnImage))
            userImage.layer.cornerRadius = 20.0
            
            recipeService.getRecipes() { recipes in
                recipes.forEach() { recipe in
                    if self.userOwnRecipes.contains(recipe.recipe_id){
                        self.tmpUserRecipes.append(recipe)
                    }
                }
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                    self.progressBar.isHidden = true
                }
            }
        } else {
            self.progressBar.isHidden = true
            if Auth.auth().currentUser?.uid != nil {
                loginMessage.isHidden = true
                loginButton.isHidden = true
                logoImage.isHidden = true
                
                recipeTableView.reloadData()
                recipeTableView.isHidden = false
                newRecipeButton.isHidden = false
                friendsButton.isHidden = false
                favouritesButton.isHidden = false
                addFriendButton.isHidden = true
                removeFriendButton.isHidden = true
                settingsButton.isHidden = false
                userImage.isHidden = false
                username.isHidden = false
                userfullname.isHidden = false
                settingsButton.isHidden = false
                emptyMessageLocal.isHidden = true
                
                DispatchQueue.main.async {
                    let userManager = UserDataManager(context: self.context)
                    if let tmp = userManager.getUser(uid: Auth.auth().currentUser!.uid) {
                        self.userfullname.text = tmp.fullname
                        self.username.text = tmp.username
                    }
                }
                
                let recipeManager = RecipeEntityManager(context: context)
//                tmpLocalRecipes = recipeManager.getAllRecipes()
                tmpLocalRecipes = recipeManager.getUserRecipes(uid: Auth.auth().currentUser!.uid)
                recipeTableView.reloadData()
            } else {
                loginMessage.isHidden = false
                loginButton.isHidden = false
                logoImage.isHidden = false
                
                recipeTableView.isHidden = true
                newRecipeButton.isHidden = true
                friendsButton.isHidden = true
                favouritesButton.isHidden = true
                addFriendButton.isHidden = true
                removeFriendButton.isHidden = true
                userImage.isHidden = true
                username.isHidden = true
                userfullname.isHidden = true
                settingsButton.isHidden = true
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLocalUser {
            if tmpLocalRecipes.count == 0{
                emptyMessageLocal.isHidden = false
                view.addSubview(emptyMessageLocal)
                emptyMessageLocal.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                emptyMessageLocal.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            } else {
                emptyMessageLocal.isHidden = true
            }
            return tmpLocalRecipes.count
        } else {
            if tmpUserRecipes.count == 0 {
                emptyMessage.isHidden = false
                view.addSubview(emptyMessage)
                emptyMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                emptyMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            } else {
                emptyMessage.isHidden = true
            }
            return tmpUserRecipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLocalUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
            cell.recipeTitle.text = tmpLocalRecipes[indexPath.row].title
            cell.recipeImage.image = UIImage(named: "cookitlogo")
            cell.delegate = self
            
            return cell
        } else {
            if indexPath.row > tmpUserRecipes.count {
                return UITableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
                cell.recipeImage.sd_setImage(with: URL(string: tmpUserRecipes[indexPath.row].img ?? ""))
                cell.recipeTitle.text = tmpUserRecipes[indexPath.row].title
                cell.layer.cornerRadius = 30.0
                cell.delegate = self
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLocalUser {
            performSegue(withIdentifier: "localRecipeDetail", sender: self)
        } else {
            performSegue(withIdentifier: "detail", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeManager = RecipeEntityManager(context: context)
        
        if segue.identifier == "localRecipeDetail" {
            let destination = segue.destination as! RecipeDetailViewController
            destination.id = String(recipeManager.getAllRecipes()[recipeTableView.indexPathForSelectedRow!.row].recipe_id)
            destination.segueName = "localRecipeDetail"
        } else if segue.identifier == "createNewRecipe" {
            let destination = segue.destination as! NewRecipeViewController
            destination.isEditingRecipe = false
        } else if segue.identifier == "detail" {
            let destination = segue.destination as! RecipeDetailViewController
            let indexPath = recipeTableView.indexPathForSelectedRow
            let row = indexPath?.row
            destination.id = String(tmpUserRecipes[row!].recipe_id)
            destination.segueName = "detail"
        }
    }
    
    func button(button: UIButton, touchedIn cell: RecipeCell) {
        if Auth.auth().currentUser?.uid != nil {
            if let indexPath = recipeTableView.indexPath(for: cell) {
                if button.tag == 0 {
                    let favouriteManager = FavouriteEntityManager(context: context)
                    let recipeManager = RecipeEntityManager(context: context)
                    if isLocalUser {
                        if favouriteManager.getFavourite(id: String(tmpLocalRecipes[indexPath.row].recipe_id)) == nil {
                            let tmpRecipe = recipeManager.getRecipe(id: String(tmpLocalRecipes[indexPath.row].recipe_id))
                            let favourite = FavouriteRecipe(context: context)
                            favourite.favouriteRecipeID = String(tmpRecipe!.recipe_id)
                            favourite.userId = Auth.auth().currentUser?.uid ?? ""
                            favourite.favouriteRecipeTitle = tmpRecipe?.title
                            favourite.favouriteRecipeIngredients = tmpRecipe?.ingredients
                            favourite.favouriteRecipeProcess = tmpRecipe?.process
                            
                            favouriteManager.createFavoutite(recipe: favourite)
                            let alert = UIAlertController(title: "Receta favorita", message: "Agregaste esta receta!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Aceptar", style: .default)
                            alert.addAction(action)
                            present(alert, animated: true)
                        } else {
                            if let deleteFavourite = favouriteManager.getFavourite(id: String(tmpLocalRecipes[indexPath.row].recipe_id)) {
                                favouriteManager.deleteFavourite(favourite: deleteFavourite)
                                let alert = UIAlertController(title: "Receta favorita eliminada", message: "Eliminaste esta receta de tus favoritas", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Aceptar", style: .default)
                                alert.addAction(action)
                                present(alert, animated: true)
                            } else {
                                print("no se pudo eliminar de favoritos")
                            }
                        }
                    } else {
                        if favouriteManager.getFavourite(id: String(tmpUserRecipes[indexPath.row].recipe_id)) == nil {
                            recipeService.getRecipeDetail(id: String(tmpUserRecipes[indexPath.row].recipe_id)) { detail in
                                let favourite = FavouriteRecipe(context: self.context)
                                favourite.favouriteRecipeID = String(self.tmpUserRecipes[indexPath.row].recipe_id)
                                favourite.userId = Auth.auth().currentUser?.uid ?? ""
                                favourite.favouriteRecipeTitle = detail.title
                                favourite.favouriteRecipeIngredients = detail.ingredients
                                favourite.favouriteRecipeProcess = detail.process
                                
                                favouriteManager.createFavoutite(recipe: favourite)
                            }
                            let alert = UIAlertController(title: "Receta favorita", message: "Agregaste esta receta!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Aceptar", style: .default)
                            alert.addAction(action)
                            present(alert, animated: true)
                        } else {
                            if let deleteFavourite = favouriteManager.getFavourite(id: String(tmpUserRecipes[indexPath.row].recipe_id)) {
                                favouriteManager.deleteFavourite(favourite: deleteFavourite)
                                let alert = UIAlertController(title: "Receta favorita eliminada", message: "Eliminaste esta receta de tus favoritas", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Aceptar", style: .default)
                                alert.addAction(action)
                                present(alert, animated: true)
                            } else {
                                print("no se pudo eliminar de favoritos")
                            }
                        }
                    }
                }
                if button.tag == 1 {
                    print("comment")
                }
                if button.tag == 2 {
                    print("share")
                }
            }
        } else {
            let alert = UIAlertController(title: "Se requiere iniciar sesión", message: "Para hacer uso de esta característica se debe iniciar sesión", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    @IBAction func addFriendAction(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            let friendManager = FriendEntityManager(context: context)
            if friendManager.getFriend(friendId: userOwnID, userId: Auth.auth().currentUser!.uid) == nil {
                let friendTmp = FriendEntity(context: context)
                friendTmp.friendId = userOwnID
                friendTmp.userId = Auth.auth().currentUser?.uid ?? ""
                friendManager.createFriend(friendId: friendTmp)
                let alert = UIAlertController(title: "Nuevo amigo", message: "Agregaste a este usuario", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                print("No se pudo agregar a este usuario")
            }
        } else {
            let alert = UIAlertController(title: "Se requiere iniciar sesión", message: "Para hacer uso de esta característica se debe iniciar sesión", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    @IBAction func deleteFriendAction(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            let friendManager = FriendEntityManager(context: context)
            if let friendTmp = friendManager.getFriend(friendId: userOwnID, userId: Auth.auth().currentUser!.uid){
                friendManager.deleteFriend(friend: friendTmp)
                let alert = UIAlertController(title: "Eliminar amigo", message: "Eliminaste a este usuario", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                print("No se pudo eliminar amigo")
            }
        } else {
            let alert = UIAlertController(title: "Se requiere iniciar sesión", message: "Para hacer uso de esta característica se debe iniciar sesión", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    @IBAction func createNewRecipeButton(_ sender: Any) {
        performSegue(withIdentifier: "createNewRecipe", sender: self)
    }
    
}
