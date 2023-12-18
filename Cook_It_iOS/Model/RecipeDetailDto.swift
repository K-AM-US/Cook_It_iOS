//
//  RecipeDetailDto.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 02/11/23.
//

import Foundation

struct RecipeDetailDto: Codable {
    var title: String
    var ingredients: [String]
    var process: [String]
    var image: String
}
