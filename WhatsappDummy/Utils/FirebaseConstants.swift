//
//  FirebaseConstants.swift
//  WhatsappDummy
//
//  Created by abhay mundhara on 03/06/2024.
//

import Foundation
import Firebase
import FirebaseDatabase

enum FirebaseConstants {
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
    static let ChannelsRef = DatabaseRef.child("channels")
    static let MessagesRef = DatabaseRef.child("channel-messages")
    static let UserChannelsRef = DatabaseRef.child("user-channels")
    static let UserDirectChannels = DatabaseRef.child("user-direct-channels")
    
}
