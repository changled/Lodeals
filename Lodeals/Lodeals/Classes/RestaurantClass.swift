//
//  RestaurantClass.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation
import os.log

class Restaurant {
    var name : String
    var id : String
    var locationStr : String
    var images : [String]
    var tags : [String]
    var price : Int
    let priceDict : [Int: String] = [-1: "err", 0: "$", 1: "$$", 2: "$$$", 3: "$$$$", 4: "$$$$$"]
    let priceDictStrToInt : [String: Int] = ["err": -1, "$": 0, "$$": 1, "$$$": 2, "$$$$": 3, "$$$$$": 4]
    var deals : [Deal]
    var priceStr : String
    var yelpURL : String?
    var alias : String
    var yelpRating : Float?
    var yelpReviewCount : Int?
    var phoneNumber : String?
    
    init(name: String = "", id: String = "", location: String = "", images: [String] = [], tags: [String] = ["tag1", "tag2"], price: Int = -1, deals: [Deal] = [], priceStr: String = "err", alias: String = "") {
        self.name = name
        self.locationStr = location
        self.tags = tags
        self.deals = deals
        self.images = images
        self.price = price
        self.priceStr = priceStr
        self.id = id
        self.alias = alias
        
        // Edge case: If only one of price or priceStr is specified, set the other to default
        if priceStr == "err" && price != -1 {
            self.priceStr = self.priceDict[price]!
        }
        else if price == -1 && priceStr != "err" {
            self.price = self.priceDictStrToInt[priceStr]!
        }
    }
    
    /*
     * Get data asynchronously with DispatchQueue so it'll load much faster
     * Due to the asynchronous nature of this, a callback is needed
     * Creates a request from the provided apiYelpURL and returns an array of Restaurant's, to be retrieved (and table view reloaded) when completed in MasterVC's viewDidLoad() function
     */
    class func getRestaurantsFromSearch (apiYelpURL: String, completionHandler: @escaping (_: [Restaurant]) -> ()) {
        var restaurants: [Restaurant] = []
        var request = URLRequest(url: URL(string: apiYelpURL)!)
        request.addValue("Bearer qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx", forHTTPHeaderField: "Authorization") //my personal Yelp api key
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            if let data = receivedData {
                do {
                    let decoder = JSONDecoder()
                    let yelpServiceBusinessSearchWithKeyword = try decoder.decode(YelpServiceBusinessSearchWithKeyword.self, from: data)
                    restaurants = getRestaurantsFromStruct(businesses: yelpServiceBusinessSearchWithKeyword)
                    completionHandler(restaurants)
                } catch {
                    print("\nException on Decode (getRestaurantsFromSearch): \(error)\n")
                }
            }
        }
        
        task.resume()
    }

    /*
     * Update details of a specific restaurant given the apiYelpURL through a single business search using a unique identifier:
     * apiYelpURL format: https: //api.yelp.com/v3/businesses/north-india-restaurant-san-francisco"
     * Note: This function is temporary and should be updated
     * Note: If class func, can't refer to self b/c it'll be self's TYPE
     */
    class func getBusinessDetails(restaurant: Restaurant, completionHandler: @escaping (_: Restaurant) -> ()) {
        var businessStruct: YelpServiceBusiness?
        let apiYelpURL = getBusinessDetailsCall(restaurant: restaurant)
        
        var request = URLRequest(url: URL(string: apiYelpURL)!)
        request.addValue("Bearer qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            if let data = receivedData {
                do {
                    let decoder = JSONDecoder()
                    businessStruct = try decoder.decode(YelpServiceBusiness.self, from: data)
                    
                    restaurant.updateRestaurantFromDetailSearch(businessStruct: businessStruct!)
                    print("\n\nBUSINESS STRUCT IMAGES: \(String(describing: businessStruct?.photos))\n\n")
//                    restaurant.printRestaurantDetails()
                    
                    completionHandler(restaurant)
                } catch {
                    print("Exception on Decode (getBusinessDetails): \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    /*
     * Used if you want only one restaurant's details:
     *   Applied to Restaurant objects instantiated in MasterVC to avoid duplicate data retrieval
     *   Will additionally add phone number; yelp rating, rating, and URL; and photos from struct and append to current Restaurant's images
     # TO-DO: RETRIEVE DEALS DATA FROM DATABASE
     */
    func updateRestaurantFromDetailSearch(businessStruct: YelpServiceBusiness) {
        phoneNumber = businessStruct.phone
        yelpRating = businessStruct.rating
        yelpReviewCount = businessStruct.review_count
        yelpURL = businessStruct.url
        
//        var repeatPhotoFlag = false
        // skip first photo since we already have it
        print("images from API(\(String(describing: businessStruct.photos?.count))): \(String(describing: businessStruct.photos))")
        
        if images.count <= (businessStruct.photos?.count)! {
            for (index, photo) in (businessStruct.photos?.enumerated())! {
                if !images.contains(photo) {
                    images.append(photo)
                }
                else {
                    print("repeat!: \(photo)")
                }
                
                print("\nclass images(\(index), \(photo)): \(images)\n")
            }
        }
    }
    
    // Simply prints out simple details for this particular restaurant
    func printRestaurant() {
        print("\(name) -- \(String(describing: id))")
        print("\t alias: \(String(describing: alias))")
        print("\t location: \(String(describing: locationStr))")
        print("\t price: \(String(describing: priceStr)) -- \(String(describing: price))")
        print("\t tags: \(String(describing: tags))")
        print("\t deals count: \(String(describing: deals.count))")
        print("\t tags: \(String(describing: tags))")
        print("\t images: \(String(describing: images))")
    }
    
    func printRestaurantDetails() {
        self.printRestaurant()
        
        print("\t yelp url: \(String(describing: yelpURL))")
        print("\t yelp rating: \(String(describing: yelpRating))")
        print("\t yelp review count: \(String(describing: yelpReviewCount))")
        print("\t phone number: \(String(describing: phoneNumber))")
        print("\t deals count: \(String(describing: deals.count))")
    }
}

class Location {
    
}
