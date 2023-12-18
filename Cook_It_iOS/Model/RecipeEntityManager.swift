//
//  RecipeEntityManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 28/11/23.
//

import Foundation
import CoreData
import UIKit

class RecipeEntityManager {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Create Recipe
    func createRecipe(recipe: RecipeEntity) {
        do {
            try context.save()
        } catch let error {
            print("Error Creando nueva receta: ", error)
        }
    }
    
    // Read Recipes
    func getAllRecipes() -> [RecipeEntity] {
        if let recipes = try? self.context.fetch(RecipeEntity.fetchRequest()) {
            return recipes
        } else {
            return []
        }
    }
    
    func getRecipe(id: String) -> RecipeEntity? {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        var predicate: NSPredicate?
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(RecipeEntity.recipe_id), id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let recipe = try context.fetch(fetchRequest)
            return recipe.first
        } catch let error {
            print("Error recuperando receta por ID: ", error)
            return nil
        }
    }
    
    func getUserRecipes(uid: String) -> [RecipeEntity] {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        var predicate: NSPredicate?
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(RecipeEntity.creatorId), uid as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes
        } catch let error {
            print("Error recuperando recetas de los usuarios: ", error)
            return []
        }
    }
    
    func updateRecipe(recipe: RecipeEntity, title: String, ingredients: [String], process: [String]){
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.process = process
        do {
            try context.save()
        } catch let error {
            print("Error no se pudo actualizar receta: ", error)
        }
    }
    
    func deleteRecipe(recipe: RecipeEntity) {
        self.context.delete(recipe)
        do {
            try context.save()
        } catch let error {
            print("Error no se pudo borrar receta", error)
        }
    }
}
