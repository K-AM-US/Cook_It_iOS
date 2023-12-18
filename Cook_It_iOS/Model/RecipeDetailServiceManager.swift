//
//  RecipeDetailServiceManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 02/11/23.
//

import Foundation

class RecipeDetailServiceManager {
    func getRecipeDetail(id: String, completion: @escaping () -> Void) -> RecipeDetailDto {
        
        guard let url = URL(string: Constants.baseUrl + "recipe" + id)
    }
}
