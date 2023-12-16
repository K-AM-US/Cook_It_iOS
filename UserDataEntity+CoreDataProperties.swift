//
//  UserDataEntity+CoreDataProperties.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 14/12/23.
//
//

import Foundation
import CoreData


extension UserDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataEntity> {
        return NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
    }

    @NSManaged public var uid: String?
    @NSManaged public var fullname: String?
    @NSManaged public var username: String?

}

extension UserDataEntity : Identifiable {

}
