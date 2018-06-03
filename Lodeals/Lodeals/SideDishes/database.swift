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
var dealCollectionRef = db.collection("deals")

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

/*
 * Create a new document with autoID to Firestore
 * Write the autoID to the given restaurant's deals array
 * Decided to keep "deals" field in "restaurant" document as an array of Strings because even though it'll be more expensive to get "restaurant" data and then "set" it, it's more often we'll retrieve deals data (less expensive) than than to set it
 */
func dbAddDeal(restaurant: Restaurant, deal: Deal) {
    let dealData: [String : Any] = [
        "restaurant": ["name": restaurant.name, "id": restaurant.id],
        "title": deal.shortDescription,
        "description": deal.description,
        "verifications": 1 //just use as a count for now; one because whoever created it automatically verifies it by default
    ]
    
    let dealDocumentRef = dealCollectionRef.addDocument(data: dealData) {
        err in
        if let err = err {
            print("Error writing deal \(deal.shortDescription) into database: \(err)")
        } else {
            print("Deal \(deal.shortDescription) for restaurant \(restaurant.name) successfully written into database")
        }
    }
    
    let restDocumentRef = restCollectionRef.document(restaurant.id)
    var restDealsArr : [String] = []
    
    restDocumentRef.getDocument { (document, err) in
        if let document = document, document.exists {
            restDealsArr = document.data()["deals"] as! [String]
        }
    }

    restDealsArr.append(dealDocumentRef.documentID)
    
    restDocumentRef.updateData([
        "deals": restDealsArr
    ]) { err in
        if let err = err {
            print("Error adding to restaurant \(restaurant.name)'s new deal \(deal.shortDescription) with id \(dealDocumentRef.documentID): \(err)")
        }
        else {
            print("Deal \(deal.shortDescription) with id \(dealDocumentRef.documentID) successfully added to restaurant \(restaurant.name)")
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
