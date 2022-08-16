//
//  UserDetails.swift
//  Rhythm
//
//  Created by Parth Antala on 2022-08-12.
//

import Firebase

struct UserDetails {
    
    //MARK: - This item will be saved on Firebase under a user
    
    //MARK: - These are the properties for a grocery item
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let email: String
    
    init(name: String, email: String,key: String = "") {
        //MARK: - Regular offline init, there will be database reference
        self.ref = nil
        self.key = key
        self.name = name
        self.email = email
        
    }
    
    init?(snapshot: DataSnapshot) {
        //MARK: - Database is taking a snapshot of the grovery item once it has been initialized, sends item to Firebase database
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["comment"] as? String,
            let email = value["trackId"] as? String
        else {
            return nil
        }
           
        //MARK: - Read items from online and set them within our app as grocery items
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.email = email
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "email": email
        ]
    }
    
    
}
