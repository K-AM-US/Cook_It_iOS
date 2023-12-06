//
//  FriendEntity+CoreDataProperties.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 04/12/23.
//
//

import Foundation
import CoreData


extension FriendEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendEntity> {
        return NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
    }

    @NSManaged public var friendId: String?

}

extension FriendEntity : Identifiable {

}
