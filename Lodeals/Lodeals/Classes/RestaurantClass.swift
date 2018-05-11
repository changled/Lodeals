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
    var location : String
    var images : [String]
    var tags : [String]
    var price : Int
    let priceDict : [Int: String] = [-1: "err", 0: "$", 1: "$$", 2: "$$$", 3: "$$$$", 4: "$$$$$"]
    var deals : [Deal]
    
    init(name: String = "", location: String = "", images: [String] = ["imageStr"], tags: [String] = ["tag1", "tag2"], price: Int = -1, deals: [Deal]) {
        self.name = name
        self.location = location
        self.tags = tags
        self.price = price
        self.deals = deals
        self.images = images
    }
}
