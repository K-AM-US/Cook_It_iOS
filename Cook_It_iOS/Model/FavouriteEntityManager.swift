//
//  FavouriteEntityManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 05/12/23.
//

import Foundation
import CoreData
import UIKit

class FavouriteEntityManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createFavoutite(recipe: FavouriteRecipe) {
        do {
            try context.save()
        } catch let error {
            print("Error creando receta favorita: ", error)
        }
    }
    
    func getAllRecipes() -> [FavouriteRecipe] {
        if let favourites = try? self.context.fetch(FavouriteRecipe.fetchRequest()) {
            return favourites
        } else {
            return []
        }
    }
    
    func getUserRecipes(uid: String) -> [FavouriteRecipe] {
        let fetchRequest = NSFetchRequest<FavouriteRecipe>(entityName: "FavouriteRecipe")
        var predicate: NSPredicate?
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(FavouriteRecipe.userId), uid as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes
        } catch let error {
            print("Error recuperando recetas favoritas de los usuarios: ", error)
            return []
        }
    }
    
    func getFavourite (id: String) -> FavouriteRecipe? {
        let fetchRequest = NSFetchRequest<FavouriteRecipe>(entityName: "FavouriteRecipe")
        var predicate: NSPredicate?
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(FavouriteRecipe.favouriteRecipeID), id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let favourite = try context.fetch(fetchRequest)
            return favourite.first
        } catch let error {
            print("Error recuperando receta favorita: ", error)
            return nil
        }
    }
    
    func updateFavouriteRecipe(recipe: FavouriteRecipe, title: String, ingredients: [String], process: [String]){
        recipe.favouriteRecipeTitle = title
        recipe.favouriteRecipeIngredients = ingredients
        recipe.favouriteRecipeProcess = process
        do {
            try context.save()
        } catch let error {
            print("Error no se pudo actualizar receta: ", error)
        }
    }
    
    func deleteFavourite(favourite: FavouriteRecipe) {
        self.context.delete(favourite)
        
        do {
            try context.save()
        } catch let error {
            print("Error eliminando receta favorita: ", error)
        }
    }
}
