//
//  UserItem.swift
//  WhatsappDummy
//
//  Created by abhay mundhara on 03/06/2024.
//

import Foundation

struct UserItem: Identifiable, Hashable, Decodable {
    let uid: String
    let username: String
    let email: String
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String {
        return uid
    }
    
    var bioUnwrapped: String {
        return bio ?? "Hey there!"
    }
    
    static let placeholder = UserItem(uid: "1", username: "abhay", email: "am@gmail.com")
    
    static let placeholders: [UserItem] = [
        UserItem(uid: "1", username: "abhay", email: "am@gmail.com"),
        UserItem(uid: "2", username: "john", email: "john.doe@gmail.com", bio: "hey there"),
        UserItem(uid: "3", username: "jane", email: "jane.doe@gmail.com", bio: "hey there"),
        UserItem(uid: "4", username: "alice", email: "alice.smith@gmail.com", bio: "hey there"),
        UserItem(uid: "5", username: "bob", email: "bob.johnson@gmail.com", bio: "hey there"),
        UserItem(uid: "6", username: "charlie", email: "charlie.brown@gmail.com", bio: "hey there"),
        UserItem(uid: "7", username: "dave", email: "dave.williams@gmail.com", bio: "hey there"),
        UserItem(uid: "8", username: "eva", email: "eva.jones@gmail.com", bio: "hey there"),
        UserItem(uid: "9", username: "frank", email: "frank.miller@gmail.com", bio: "hey there"),
        UserItem(uid: "10", username: "grace", email: "grace.davis@gmail.com", bio: "hey there")
    ]
}

extension UserItem {
    init(dictionary: [String: Any]) {
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? nil
    }
}


extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
