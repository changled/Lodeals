//
//  database.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/16/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation
import Firebase

let db = Firestore.firestore()

// add a new document with a generated ID
var ref : DocumentReference? = nil
var restCollectionRef = db.collection("restaurants")

/*
 * First time adding a restaurant to the Firestore
 * Creates a new document with its appropriate id
 * Note: Does not add any deals
 */
func dbInitAddRestaurant(restaurant: Restaurant) {
    
    print("\nINSIDE DB INITIAL ADD RESTAURANT")
    restCollectionRef = db.collection("restaurants")
    
    let restData: [String : Any] = [
        "name": restaurant.name,
        "deals": []
    ]
    
    restCollectionRef.document(restaurant.id).setData(restData) {
        err in
        if let err = err {
            print("Error writing restaurant \(restaurant.name) into database: \(err)")
        } else {
            print("Restaurant \(restaurant.name) successfully written into database")
        }
    }
}

func addFirstDocument() {
    ref = db.collection("restaurants").addDocument(data: [
        "name": "Blaze Fast Fire'd Pizza",
        "location": "San Luis Obispo on Foothill",
        "tags": ["cheap", "fast", "pizza", "American"],
        "price": 1
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref!.documentID)")
        }
    }
}

func addSecondDocument() {
    ref = db.collection("restaurants").addDocument(data: [
        "name": "TASTE",
        "location": "in San Luis Obispo somewhere",
        "tags": ["tapas/small plates", "American", "gluten-free"],
        "price": 2
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref!.documentID)")
        }
    }
}

func readData() {
    db.collection("restaurants").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
}
