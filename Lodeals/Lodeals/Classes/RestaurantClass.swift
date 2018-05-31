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
    
    init(name: String = "", id: String = "", location: String = "", images: [String] = ["imageStr"], tags: [String] = ["tag1", "tag2"], price: Int = -1, deals: [Deal] = [], priceStr: String = "err") {
        self.name = name
        self.location = location
        self.tags = tags
        self.deals = deals
        self.images = images
        self.price = price
        self.priceStr = priceStr
        self.id = id
        
        if priceStr == "err" && price != -1 {
            self.priceStr = self.priceDict[price]!
        }
        else if price == -1 && priceStr != "err" {
            self.price = self.priceDictStrToInt[priceStr]!
        }
    }
    
    func printRestaurant() {
        print("\(name) --")
        print("\t id: \(String(describing: id))")
        print("\t location: \(String(describing: location))")
        print("\t price: \(String(describing: price))")
        print("\t priceStr: \(String(describing: priceStr))")
        print("\t tags: \(String(describing: tags))")
        print("\t deals count: \(String(describing: deals.count))")
    }
}
