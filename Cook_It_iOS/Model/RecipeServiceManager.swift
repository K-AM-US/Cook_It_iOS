//
//  RecipeServiceManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 23/10/23.
//

import Foundation

class RecipeServiceManager {
    private var loadedRecipes: [RecipeDto] = []
    
    func countRecipes() -> Int {
        return loadedRecipes.count
    }
    
    func getRecipe(at index: Int) -> RecipeDto? {
        return loadedRecipes[index]
    }
    
    
    func getRecipes(completion: @escaping ([RecipeDto]) -> Void){
        guard let url = URL(string: Constants.recipes) else {
            return
        }
        
        let recipe = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let data = data {
                do {
                    let recipes = try JSONDecoder().decode([RecipeDto].self, from: data)
                    recipes.forEach { recipeResponse in
                        self.loadedRecipes.append(recipeResponse)
                    }
                    completion(recipes)
                } catch {
                    print(error)
                }
                
            }
        }
        recipe.resume()
    }
    
    func getRecipeDetail(id: String, completion: @escaping (RecipeDetailDto) -> Void) {
        guard let url = URL(string: Constants.baseUrl + "recipe/" + id) else {
            return
        }
        let recipe = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let recipeDetail = try JSONDecoder().decode(RecipeDetailDto.self, from: data)
                    completion(recipeDetail)
                } catch {
                    print(error)
                }

            }
        }
        recipe.resume()
    }
}
