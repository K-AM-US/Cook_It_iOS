//
//  UserDataManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 14/12/23.
//

import Foundation
import CoreData
import UIKit

class UserDataManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createUser(user: UserDataEntity) {
        do {
            print("se creo el usuario")
            try context.save()
        } catch let error {
            print("Error creando usuario: ", error)
        }
    }
    
    func getAllUsers() -> [UserDataEntity] {
        if let user = try? self.context.fetch(UserDataEntity.fetchRequest()) {
            return user
        } else {
            return []
        }
    }
    
    func getUser(uid: String) -> UserDataEntity? {
        let fetchRequest = NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
        let predicate: NSPredicate?
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(UserDataEntity.uid), uid as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let user = try context.fetch(fetchRequest)
            return user.first
        } catch let error {
            print("Error recuperando usuario por uid: ", error)
            return nil
        }
    }
    
    func updateUser(user: UserDataEntity, name: String, username: String) {
        user.fullname = name
        user.username = username
        do {
            try context.save()
        } catch let error {
            print("Error al actualizar usuario")
        }
        
    }
}
