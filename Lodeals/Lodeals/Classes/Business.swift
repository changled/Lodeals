//
//  Business.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/17/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation

//taken from github from user codepath (github.com/codepath/ios_yelp_swift/blob/master/Yelp/Business.swift)
class Business: NSObject {
    let id: String?
    let name: String?
    let url: String?
    let rating: Float?
    let price: String?
    let phone: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let isOpenNow: Bool?
    var longitude: Double?
    var latitude: Double?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        url = dictionary["url"] as? String
        rating = dictionary["rating"] as? Float
        price = dictionary["price"] as? String
        phone = dictionary["phone"] as? String
        isOpenNow = dictionary["is_open_now"] as? Bool
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let coordinates = dictionary["coordinates"] as? NSDictionary
        if coordinates != nil {
            self.longitude = coordinates!["longitude"] as? Double
            self.latitude = coordinates!["latitude"] as? Double
        }
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
    }
    
    class func getBusinesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        
        return businesses
    }
    
//    class func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
//        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
//    }
//
//    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
//        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
//    }
}

    

