//
//  RestaurantClass.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation
import os.log
// updated Restaurant class, added Deal class

class Restaurant {
    var name : String
    var location : String
    var image : String
    var tags : [String]
    var price : Int
    let priceDict : [Int: String] = [-1: "err", 0: "$", 1: "$$", 2: "$$$", 3: "$$$$", 4: "$$$$$"]
    var deals : [Deal]
    
    init(name: String = "", location: String = "", image: String = "imageStr", tags: [String] = ["tag1", "tag2"], price: Int = -1, deals: [Deal]) {
        self.name = name
        self.location = location
        self.image = image
        self.tags = tags
        self.price = price
        self.deals = deals
    }
}

class Deal {
    var shortDescription : String
    var description : String
    var totalTimesUsed : Int
    var userTimesUsed : Int
//    var lastUse : Date
    var lastUsed : DateComponents
    
    init(shortDescription: String = "", description: String = "", totalTimesUsed: Int = 0, userTimesUsed: Int = 0, lastUsed: DateComponents) {
        self.shortDescription = shortDescription
        self.description = description
        self.totalTimesUsed = totalTimesUsed
        self.userTimesUsed = userTimesUsed
//        self.lastUse = lastUse
        self.lastUsed = lastUsed
    }
    
    func setLastUse(year: Int = 2001, month: Int = 1, day: Int = 1, hour: Int = 1, minute: Int = 1) {
        lastUsed.year = year
        lastUsed.month = month
        lastUsed.day = day
        lastUsed.hour = hour
        lastUsed.minute = minute
    }
    
    func getLastUseStr() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let diffYear = calendar.component(.year, from: now) - lastUsed.year!
        if(diffYear >= 1) {
            return ("...\(diffYear) years ago")
        }
        
        let diffMonth = calendar.component(.month, from: now) - lastUsed.month!
        if(diffMonth >= 1) {
            return ("...\(diffMonth) months ago")
        }
        
        let diffDay = calendar.component(.day, from: now) - lastUsed.day!
        if(diffDay >= 1) {
            return ("...\(diffDay) days ago")
        }
        
        let diffHour = calendar.component(.hour, from: now) - lastUsed.hour!
        if(diffHour >= 1) {
            return ("...\(diffHour) hours ago")
        }
        
        let diffMin = calendar.component(.minute, from: now) - lastUsed.minute!
        return ("...\(diffMin) min ago")
    }
}
