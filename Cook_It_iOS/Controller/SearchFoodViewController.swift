//
//  SearchFoodViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 12/11/23.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchFoodViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, RecipeCellDelegate {

    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var searchTable: UITableView!
    
    private var recipes: [RecipeDto] = []
    private var filteredRecipes: [RecipeDto] = []
    private let categoryServiceManager = CategoryServiceManager()
    private let recipeServiceManager = RecipeServiceManager()
    
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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        
        searchTable.dataSource = self
        searchTable.delegate = self
        
        view.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        progressBar.startAnimating()
        progressBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if InternetMonitor.shared.internetStatus {
            buttonReload.isHidden = true
            searchBar.isHidden = false
            categoryCollection.isHidden = false
            searchTable.isHidden = false
            categoryServiceManager.getCategories(){
                DispatchQueue.main.async {
                    self.categoryCollection.reloadData()
                }
            }
            recipeServiceManager.getRecipes(){ recipes in
                self.recipes = recipes
                self.filteredRecipes = recipes
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                    self.progressBar.isHidden = true
                }
            }
        } else {
            progressBar.isHidden = true
            buttonReload.isHidden = false
            networkMessage.isHidden = false
            searchBar.isHidden = true
            categoryCollection.isHidden = true
            searchTable.isHidden = true
            
            view.addSubview(networkMessage)
            networkMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            networkMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
            
            view.addSubview(buttonReload)
            buttonReload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonReload.topAnchor.constraint(equalTo: networkMessage.bottomAnchor, constant: 130).isActive = true
            buttonReload.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
    }
    
    @objc func reload() {
        viewDidAppear(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryServiceManager.countCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row > categoryServiceManager.countCategories()){
            return UICollectionViewCell()
        } else {
            let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            
            cell.categoryImage.sd_setImage(with: URL(string: categoryServiceManager.getCategory(at: indexPath.row).category_icon))
            cell.categoryTitle.text = categoryServiceManager.getCategory(at: indexPath.row).category
            cell.layer.cornerRadius = 30.0
            cell.backgroundColor = .gray
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteredRecipes = []
        recipes.forEach() { recipe in
            if recipe.type == categoryServiceManager.getCategory(at: indexPath.row).category  {
                filteredRecipes.append(recipe)
            }
            if indexPath.row == 0 {
                filteredRecipes = recipes
            }
        }
        self.searchTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > recipeServiceManager.countRecipes() {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
            
            let recipe = filteredRecipes[indexPath.row]
            
            cell.recipeImage.sd_setImage(with: URL(string: recipe.img ?? ""))
            cell.recipeTitle.text = recipe.title
            cell.layer.cornerRadius = 30.0
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            let destination = segue.destination as! RecipeDetailViewController
            
            let indexPath = searchTable.indexPathForSelectedRow
            let row = indexPath?.row
            
            destination.id = filteredRecipes[row!].recipe_id
        } else {
        
        }
    }
    
    func button(button: UIButton, touchedIn cell: RecipeCell) {
        if Auth.auth().currentUser?.uid != nil {
            if let indexPath = searchTable.indexPath(for: cell) {
                if button.tag == 0 {
                    let favouriteManager = FavouriteEntityManager(context: context)
                    if favouriteManager.getFavourite(id:filteredRecipes[indexPath.row].recipe_id) == nil {
                        recipeServiceManager.getRecipeDetail(id: filteredRecipes[indexPath.row].recipe_id) { detail in
                            let favourite = FavouriteRecipe(context: self.context)
                            favourite.favouriteRecipeID = self.filteredRecipes[indexPath.row].recipe_id
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
                        if let deleteFavourite = favouriteManager.getFavourite(id: filteredRecipes[indexPath.row].recipe_id) {
                            favouriteManager.deleteFavourite(favourite: deleteFavourite)
                            let alert = UIAlertController(title: "Receta favorita eliminada", message: "Eliminaste esta receta de tus favoritas", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Aceptar", style: .default)
                            alert.addAction(action)
                            present(alert, animated: true)
                        } else {
                            print("No se pudo eliminar de favoritos")
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecipes = []
        recipes.forEach() { recipe in
            if recipe.title.lowercased().contains(searchText.lowercased()) ||
                recipe.tags.contains(searchText) {
                filteredRecipes.append(recipe)
            }
            if searchText == "" {
                filteredRecipes = recipes
            }
        }
        self.searchTable.reloadData()
    }
}
