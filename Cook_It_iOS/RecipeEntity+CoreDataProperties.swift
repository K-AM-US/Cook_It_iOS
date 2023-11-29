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
    @NSManaged public var title: String?
    @NSManaged public var ingredients: NSObject?
    @NSManaged public var process: NSObject?
    @NSManaged public var img: String?

}

extension RecipeEntity : Identifiable {

}
