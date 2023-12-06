//
//  SearchFoodViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 12/11/23.
//

import UIKit

class SearchFoodViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var searchTable: UITableView!
    
    private var recipes: [RecipeDto] = []
    private var filteredRecipes: [RecipeDto] = []
    private let categoryServiceManager = CategoryServiceManager()
    private let recipeServiceManager = RecipeServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        
        searchTable.dataSource = self
        searchTable.delegate = self
        
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
            }
        }
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
            destination.id = recipeServiceManager.getRecipe(at: searchTable.indexPathForSelectedRow!.row).recipe_id
        } else {
        
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
