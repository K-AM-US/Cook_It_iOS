//
//  UserServiceManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 13/11/23.
//

import Foundation

class UserServiceManager {
    private var loadedUsers: [UserDto] = []
    
    func countUsers() -> Int {
        return loadedUsers.count
    }
    
    func getUser(at index: Int) -> UserDto {
        return loadedUsers[index]
    }
    
    func getUsers(completion: @escaping ([UserDto]) -> Void) {
        guard let url = URL(string: Constants.users) else {
            return
        }
        
        let user = URLSession.shared.dataTask(with: url){ data, response, error in
            if let data = data {
                do {
                    let users = try JSONDecoder().decode([UserDto].self, from: data)
                    users.forEach() { userResponse in
                        self.loadedUsers.append(userResponse)
                    }
                    completion(users)
                } catch {
                    print(error)
                }
                
            }
        }
        user.resume()
    }
}
