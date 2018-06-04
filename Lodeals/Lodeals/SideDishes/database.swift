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
    
//    print("\n(dbInitAddRestaurant) ADDING NEW RESTAURANT \(restaurant.name)...")
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
//    print("\n(dbAddDeal) ADDING NEW DEAL \(deal.shortDescription) to \(restaurant.name)...")
    let dealData: [String : Any] = [
        "restaurant": ["name": restaurant.name, "id": restaurant.id],
        "title": deal.shortDescription,
        "description": deal.description,
        "verifications": 1, //just use as a count for now; one because whoever created it automatically verifies it by default
        "initialization": ["year": deal.lastUsed.year, "month": deal.lastUsed.month, "day": deal.lastUsed.day, "hour": deal.lastUsed.hour, "minute": deal.lastUsed.minute, "second": deal.lastUsed.second]
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
            print("   error b/c restuarant \(restaurant.name) does not exist in database (dbAddDeal): \(String(describing: err))")
        }
    }
}

/*
 * Given a Restaurant, check if it exists in Firestore and returns the appropriate boolean
 */
func dbRestaurantExists(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
//    print("\n(dbRestaurantExists) CHECKING WHETHER RESTAURANT EXISTS IN DATABASE...")
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

func dbUpdateRestaurantWithDeals(restaurant: Restaurant, completion: @escaping ([String]?) -> Void) {
//    print("\n(dbUpdateRestaurantWithDeals) GET DEALS IF RESTAURANT (\(restaurant.name) EXISTS IN DATABASE...")
    let restDocumentRef = restCollectionRef.document(restaurant.id)
    
    restDocumentRef.getDocument {
        (document, err) in
        if let document = document {
            
            if document.exists {
                print("   \(restaurant.name) exists in database: \(document.data()["name"] as! String)")
                let deals = document.data()["deals"] as! [String]
                
//                if deals.count < 1 {
//                    print("   error: no deals for \(restaurant.name) in the database")
//                }
//                else if deals.count < 2 {
//                    print("   1 deal for \(restaurant.name) found in the database with id \(deals[0])")
//                    //add deal
//                }
//                else if deals.count < 3 {
//                    print("   2 deals for \(restaurant.name) found in the database with ids \(deals[0]) and \(deals[1])")
//                }
//                else {
//                    print("   \(deals.count) deals for \(restaurant.name) found in the database with ids \(deals)")
//                }
                
                completion(deals)
            }
//            else {
//                print("   could not find \(restaurant.name) in database")
//            }
        
            if let err = err {
                print("   error in dbUpdateRestaurantWithDeals for restaurant \(restaurant.name): \(err)")
            }
        }
    }
}

/*
 * This function checks Firestore for a document with the provided id in the deals collection
 *
 */
func dbGetDealWithID(id: String, restID: String, completion: @escaping (Deal?) -> Void) {
//    print("\n(dbGetDealWithID) GET DEAL WITH ID \(id)")
    
    let dealDocumentRef = dealCollectionRef.document(id)
    
    dealDocumentRef.getDocument {
        (document, err) in
        
        if let document = document, document.exists {
            let dealDict = document.data()
//            print("   deal \(String(describing: dealDict["title"])) with id \(id) found in database (dbGetDealWithID)")
            let title = dealDict["title"] as! String
            let description = dealDict["description"] as! String
            let totalTimesUsed = dealDict["verifications"] as! Int
            let initTime = dealDict["initialization"] as! [String : Int]
            
            let newDeal = Deal(id: id, restaurantID: restID, shortDescription: title, description: description, totalTimesUsed: totalTimesUsed, lastUsed: nil)
            newDeal.setLastUse(year: initTime["year"]!, month: initTime["month"]!, day: initTime["day"]!, hour: initTime["hour"]!, minute: initTime["minute"]!)
            
            completion(newDeal)
        }
        else {
            print("   error finding deal with id \(id) in database (dbGetDealWithID): \(String(describing: err))")
        }
    }
}
// ----------------------------------------------------------------------------------------------------------------



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
