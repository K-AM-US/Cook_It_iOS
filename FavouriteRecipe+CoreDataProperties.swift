//
//  FavouriteRecipe+CoreDataProperties.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 05/12/23.
//
//

import Foundation
import CoreData


extension FavouriteRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteRecipe> {
        return NSFetchRequest<FavouriteRecipe>(entityName: "FavouriteRecipe")
    }

    @NSManaged public var favouriteRecipeID: String?
    @NSManaged public var favouriteRecipeTitle: String?
    @NSManaged public var favouriteRecipeIngredients: NSObject?
    @NSManaged public var favouriteRecipeProcess: NSObject?

}

extension FavouriteRecipe : Identifiable {

}
