//
//  GroceryItem.swift
//  FirebaseGrocery
//
//  Created by Parth Antala on 2022-07-24.
//

import Firebase

struct Comments {
    
    //MARK: - This item will be saved on Firebase under a user
    
    //MARK: - These are the properties for a grocery item
    
    let ref: DatabaseReference?
    let key: String
    let comment: String
    let trackId: String
    let id: Int
    
    init(comment: String, trackId: String,id: Int,key: String = "") {
        //MARK: - Regular offline init, there will be database reference
        self.ref = nil
        self.key = key
        self.comment = comment
        self.trackId = trackId
        self.id = id
        
    }
    
    init?(snapshot: DataSnapshot) {
        //MARK: - Database is taking a snapshot of the grocery item once it has been initialized, sends item to Firebase database
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let comment = value["comment"] as? String,
            let trackId = value["trackId"] as? String,
            let id = value["id"] as? Int
        else {
            return nil
        }
           
        //MARK: - Read items from online and set them within our app as grocery items
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.comment = comment
        self.trackId = trackId
        self.id = id
    }
    
    func toAnyObject() -> Any {
        return [
            "comment": comment,
            "trackId": trackId,
            "id": id
        ]
    }
    
    
}


