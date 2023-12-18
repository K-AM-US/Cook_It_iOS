//
//  Recipe.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 23/10/23.
//

import Foundation

struct RecipeDto: Codable {
    let recipe_id: String
    var title: String
    var type: String
    var tags: [String]
    var img: String?
}
