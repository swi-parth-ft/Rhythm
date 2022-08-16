//
//  User.swift
//  Rhythm
//
//  Created by Parth Antala on 2022-08-06.
//

import Foundation
import Firebase

struct User {
    
    //MARK: - User object properties
    let uid: String //id
    let email: String //email
    
    init(authData: Firebase.User)
    {
        //MARK: - Login with Firebase user
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        //MARK: - Login with id and email
        self.uid = uid
        self.email = email
    }
}
