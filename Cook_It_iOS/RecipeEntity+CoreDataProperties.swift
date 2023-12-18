//
//  RecipeEntity+CoreDataProperties.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 28/11/23.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var recipe_id: Int64
    @NSManaged public var creatorId: String
    @NSManaged public var title: String?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var process: [String]?
    @NSManaged public var img: String?

}

extension RecipeEntity : Identifiable {

}
