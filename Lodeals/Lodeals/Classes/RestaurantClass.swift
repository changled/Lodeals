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
    var location : String
    var images : [String]
    var tags : [String]
    var price : Int
    let priceDict : [Int: String] = [-1: "err", 0: "$", 1: "$$", 2: "$$$", 3: "$$$$", 4: "$$$$$"]
    let priceDictStrToInt : [String: Int] = ["err": -1, "$": 0, "$$": 1, "$$$": 2, "$$$$": 3, "$$$$$": 4]
    var deals : [Deal]
    var priceStr : String
    var yelpURL : String
    
    init(name: String = "", id: String = "", location: String = "", images: [String] = ["imageStr"], tags: [String] = ["tag1", "tag2"], price: Int = -1, deals: [Deal] = [], priceStr: String = "err", yelpURL: String = "https://google.com") {
        self.name = name
        self.location = location
        self.tags = tags
        self.deals = deals
        self.images = images
        self.price = price
        self.priceStr = priceStr
        self.id = id
        self.yelpURL = yelpURL
        
        /*
         * If only one of price or priceStr is specified, set the other
         * First set to default as edge case
         */
        if priceStr == "err" && price != -1 {
            self.priceStr = self.priceDict[price]!
        }
        else if price == -1 && priceStr != "err" {
            self.price = self.priceDictStrToInt[priceStr]!
        }
    }
    
    /*
     * Due to the asynchronous nature of this, a callback is needed
     * getRestaurantsFromSearch creates a request from the provided apiYelpURL and returns an array of Restaurant's, to be retrieved (and table view reloaded) when completed in MasterVC's viewDidLoad() function
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
                    print("\nException on Decode: \(error)\n")
                }
            }
        }
        
        task.resume()
    }
    
    // Simply prints out details for this particular restaurant
    func printRestaurant() {
        print("\(name) --")
        print("\t id: \(String(describing: id))")
        print("\t yelp url: \(String(describing: yelpURL))")
        print("\t location: \(String(describing: location))")
        print("\t price: \(String(describing: priceStr)) -- \(String(describing: price))")
        print("\t images: \(String(describing: images))")
        print("\t tags: \(String(describing: tags))")
        print("\t deals count: \(String(describing: deals.count))")
    }
}
