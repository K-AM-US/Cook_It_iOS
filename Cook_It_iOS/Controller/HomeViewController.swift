//
//  HomeViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 23/10/23.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var recipesTable: UITableView!
    @IBOutlet var recipesCarousel: UICollectionView!
    
    private var carouselIndex = 0
    
    private let recipeService = RecipeServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTable.dataSource = self
        recipesTable.delegate = self
        
        recipesCarousel.dataSource = self
        recipesCarousel.delegate = self
        
        recipeService.getRecipes(){ recipes in
            DispatchQueue.main.async {
                self.recipesTable.reloadData()
                self.recipesCarousel.reloadData()
            }
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            performSegue(withIdentifier: "recipeDetail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeService.countRecipes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > recipeService.countRecipes() {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
            
            cell.recipeImage.sd_setImage(with: URL(string: recipeService.getRecipe(at: indexPath.row).img ?? ""))
            cell.recipeTitle.text = recipeService.getRecipe(at: indexPath.row).title
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
            destination.id = recipeService.getRecipe(at: recipesTable.indexPathForSelectedRow!.row).recipe_id
        } else if segue.identifier == "signIn" {
            
        } else {
            let destination = segue.destination as! RecipeDetailViewController
            destination.id = recipeService.getRecipe(at:carouselIndex).recipe_id
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeService.countRecipes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row > recipeService.countRecipes()){
            return UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as! RecipeCarouselCell
            
            cell.recipeImage.sd_setImage(with: URL(string: recipeService.getRecipe(at: indexPath.row).img ?? ""))
            cell.layer.cornerRadius = 40.0
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        carouselIndex = indexPath.item
        performSegue(withIdentifier: "carouselSegue", sender: self)
    }
}

