//
//  UsersDto.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 13/11/23.
//

import Foundation

struct UserDto: Codable {
    let id: String
    var username: String
    var first_name: String
    var last_name: String
    var recipes: [String]
    var image: String
}
