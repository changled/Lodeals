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
    
    print("\n(dbInitAddRestaurant) ADDING NEW RESTAURANT \(restaurant.name)...")
    restCollectionRef = db.collection("restaurants")
    
    let restData: [String : Any] = [
        "name": restaurant.name,
        "deals": []
    ]
    
    restCollectionRef.document(restaurant.id).setData(restData) {
        err in
        if let err = err {
            print("   error writing restaurant \(restaurant.name) into database: \(err)")
        } else {
            print("   restaurant \(restaurant.name) successfully written into database")
        }
    }
}

/*
 * Create a new document with autoID to Firestore
 * Write the autoID to the given restaurant's deals array
 * Decided to keep "deals" field in "restaurant" document as an array of Strings because even though it'll be more expensive to get "restaurant" data and then "set" it, it's more often we'll retrieve deals data (less expensive) than than to set it
 */
func dbAddDeal(restaurant: Restaurant, deal: Deal) {
    print("\n(dbAddDeal) ADDING NEW DEAL \(deal.shortDescription) to \(restaurant.name)...")
    let dealData: [String : Any] = [
        "restaurant": ["name": restaurant.name, "id": restaurant.id],
        "title": deal.shortDescription,
        "description": deal.description,
        "verifications": 1 //just use as a count for now; one because whoever created it automatically verifies it by default
    ]
    
    let dealDocumentRef = dealCollectionRef.addDocument(data: dealData) {
        err in
        if let err = err {
            print("   error writing deal \(deal.shortDescription) into database: \(err)")
        } else {
            print("   deal \(deal.shortDescription) for restaurant \(restaurant.name) successfully written into database")
        }
    }
    
    let restDocumentRef = restCollectionRef.document(restaurant.id)
    
    restDocumentRef.getDocument { (document, err) in
        if let document = document, document.exists {
            var restDealsArr = document.data()["deals"] as! [String]
            restDealsArr.append(dealDocumentRef.documentID)
            
            // fixed bug: this has to be inside the closure so the deals won't get overwritten
            restDocumentRef.updateData([
                "deals": restDealsArr
            ]) { err in
                if let err = err {
                    print("   error adding to restaurant \(restaurant.name) new deal \(deal.shortDescription) with id \(dealDocumentRef.documentID): dbAddDeal -- \(err)")
                }
                else {
                    print("   deal \(deal.shortDescription) with id \(dealDocumentRef.documentID) successfully added to restaurant \(restaurant.name) (dbAddDeal): now \(restDealsArr)")
                }
            }
        }
        else {
            print("   error: restuarant \(restaurant.name) does not exist in database (dbAddDeal)")
        }
    }
}

/*
 * Given a Restaurant, check if it exists in Firestore and returns the appropriate boolean
 */
func dbRestaurantExists(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
    print("\n(dbRestaurantExists) CHECKING WHETHER RESTAURANT EXISTS IN DATABASE...")
    let restDocumentRef = restCollectionRef.document(restaurant.id)
    
    restDocumentRef.getDocument { (document, err) in
        if let document = document {
        
            if document.exists {
                print("   document exists: \(document.data()["name"] as! String)")
                completion(true)
            }
            else {
                print("   could not find document")
                completion(false)
            }
        }
    }
}

func dbUpdateRestaurantWithDeals(restaurant: Restaurant) {
    print("\n(dbUpdateRestaurantWithDeals) GET DEALS IF RESTAURANT EXISTS IN DATABASE...")
    let restDocumentRef = restCollectionRef.document(restaurant.id)
    
    restDocumentRef.getDocument { (document, err) in
        if let document = document {
            
            if document.exists {
                print("   \(restaurant.name) exists in database: \(document.data()["name"] as! String)")
                let deals = document.data()["deals"] as! [String]
                
                if deals.count < 1 {
                    print("   error: no deals for \(restaurant.name) in the database")
                }
                else if deals.count < 2 {
                    print("   one deal for \(restaurant.name) found in the database with id \(deals[0])")
                    
//                    newDeal1 = Deal(id: deals[0])
//                    (id: String = "", restaurantID: String = "", shortDescription: String = "", description: String = "", totalTimesUsed: Int = 0, userTimesUsed: Int = 0, lastUsed: DateComponents?, dealIsVerified: Bool = false)
                }
                else if deals.count < 3 {
                    print("   two deals for \(restaurant.name) found in the database with ids \(deals[0]) and \(deals[1])")
                }
                else {
                    print("   more than two deals found in the database with ids \(deals)")
                }
            }
            else {
                print("   could not find \(restaurant.name) in database")
//                completion(false)
            }
        }
    }
}

//func dbGetDealWithID() {
//
//}




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
