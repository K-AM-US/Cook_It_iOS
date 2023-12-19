//
//  FavouritesViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 05/12/23.
//

import UIKit
import Firebase
import FirebaseAuth

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecipeCellDelegate {

    @IBOutlet var favouritesTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var tmpFavouriteRecipes: [FavouriteRecipe] = []
    private let emptyMessage: UILabel = {
        let label = UILabel()
        label.text = "Añade algunas\nrecetas favoritas!."
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favouriteManager = FavouriteEntityManager(context: context)
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        
        tmpFavouriteRecipes = favouriteManager.getUserRecipes(uid: Auth.auth().currentUser!.uid)
        favouritesTableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let favouriteManager = FavouriteEntityManager(context: context)
        tmpFavouriteRecipes = favouriteManager.getUserRecipes(uid: Auth.auth().currentUser!.uid)
        favouritesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tmpFavouriteRecipes.count == 0 {
            emptyMessage.isHidden = false
            view.addSubview(emptyMessage)
            emptyMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emptyMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        } else {
            emptyMessage.isHidden = true
        }
        return tmpFavouriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        
        cell.recipeTitle.text = tmpFavouriteRecipes[indexPath.row].favouriteRecipeTitle
        cell.recipeImage.image = UIImage(named: "cookitlogo")
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favouriteRecipeDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favouriteManager = FavouriteEntityManager(context: context)
        let destination = segue.destination as! RecipeDetailViewController
            
        destination.id = favouriteManager.getUserRecipes(uid: Auth.auth().currentUser!.uid)[favouritesTableView.indexPathForSelectedRow!.row].favouriteRecipeID
        destination.segueName = "favouriteRecipeDetail"
    }
    
    func button(button: UIButton, touchedIn cell: RecipeCell) {
        if let indexPath = favouritesTableView.indexPath(for: cell) {
            if button.tag == 0 {
                let favouriteManager = FavouriteEntityManager(context: context)
                if let deleteFavourite = favouriteManager.getFavourite(id: tmpFavouriteRecipes[indexPath.row].favouriteRecipeID) {
                    favouriteManager.deleteFavourite(favourite: deleteFavourite)
                    let alert = UIAlertController(title: "Receta favorita eliminada", message: "Eliminaste esta receta de tus favoritas", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default) { result in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addAction(action)
                    present(alert, animated: true)
                    
                }
            }
            if button.tag == 1 {
                let window = UIAlertController(title: "Comentario", message: "Deja un comentario para esta receta", preferredStyle: .alert)
                window.addTextField()
                let action = UIAlertAction(title: "Comentar", style: .default) { result in
                    // se recupera el comentario y se manda al servidor
                }
                let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
                window.addAction(action)
                window.addAction(cancel)
                present(window, animated: true)
            }
            if button.tag == 2 {
                UIPasteboard.general.string = Constants.baseUrl + "recipe/" + tmpFavouriteRecipes[indexPath.row].favouriteRecipeID
                let alert = UIAlertController(title: "Link", message: "Link a la receta copiado", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
}
