//
//  FriendEntityManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 04/12/23.
//

import Foundation
import CoreData
import UIKit

class FriendEntityManager {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createFriend(friendId: FriendEntity){
        do {
            try context.save()
        } catch let error {
            print("Error agregando amigo: ", error)
        }
    }
    
    func getAllFriends() -> [FriendEntity] {
        if let friends = try? self.context.fetch(FriendEntity.fetchRequest()) {
            return friends
        } else {
            return []
        }
    }
    
    func getFriend(friendId: String, userId: String) -> FriendEntity? {
        let fetchRequest = NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
        var predicate: NSPredicate
        
        predicate = NSPredicate(format: "friendId = %@ && userId == %@", friendId, userId)
        fetchRequest.predicate = predicate
       
        
        do {
            let friend = try context.fetch(fetchRequest)
            return friend.first
        } catch let error {
            print("Error recuperando amigo por ID: ", error)
            return nil
        }
    }
    
//    func getFriend(id: String) -> FriendEntity? {
//        let fetchRequest = NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
//        var predicate: NSPredicate?
//        
//        predicate = NSPredicate(format: "%K == %@", #keyPath(FriendEntity.friendId), id as CVarArg)
//        fetchRequest.predicate = predicate
//        
//        do {
//            let friend = try context.fetch(fetchRequest)
//            return friend.first
//        } catch let error {
//            print("Error recuperando amigo por ID: ", error)
//            return nil
//        }
//    }
    
    func deleteFriend(friend: FriendEntity) {
        self.context.delete(friend)
        
        do {
            try context.save()
        } catch let error {
            print("Error borrando", error)
        }
    }
    
}
