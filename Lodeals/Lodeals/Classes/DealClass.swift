//
//  DealClass.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/8/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation

class Deal {
    var id : String
    var restaurantID : String
    var shortDescription : String
    var description : String
    var totalTimesUsed : Int
    var userTimesUsed : Int
    var lastUsed : DateComponents
//    var verificationTime : DateComponents
    var dealIsVerified : Bool //temporarily used for only me (need to optimize for any user)
    var lastlastUsed : DateComponents
    
    init(id: String = "", restaurantID: String = "", shortDescription: String = "", description: String = "", totalTimesUsed: Int = 0, userTimesUsed: Int = 0, lastUsed: DateComponents?, dealIsVerified: Bool = false) {
        self.id = id
        self.restaurantID = restaurantID
        self.shortDescription = shortDescription
        self.description = description
        self.totalTimesUsed = totalTimesUsed
        self.userTimesUsed = userTimesUsed
//        self.verificationTime = nil
        self.dealIsVerified = dealIsVerified
        
        if((lastUsed) != nil) {
            self.lastUsed = lastUsed!
        }
        else {
            self.lastUsed = DateComponents(calendar: Calendar.current)
        }
        
        self.lastlastUsed = self.lastUsed
    }
    
    func printDeal() {
        print("PRINTING DEAL \(shortDescription) with id \(id)")
        print("\tfor restaurant with id: \(restaurantID)")
        print("\ttitle: \(description)")
        print("\tdescription: \(shortDescription)")
        print("\ttotal times used: \(totalTimesUsed)")
    }
    
    func setLastUse(year: Int = 2001, month: Int = 1, day: Int = 1, hour: Int = 1, minute: Int = 1) {
        lastUsed.year = year
        lastUsed.month = month
        lastUsed.day = day
        lastUsed.hour = hour
        lastUsed.minute = minute
    }
    
    func updateLastUsedToNow(){
        let now = Date()
        let calender = Calendar.current
        
        lastUsed.year = calender.component(.year, from: now)
        lastUsed.month = calender.component(.month, from: now)
        lastUsed.day = calender.component(.day, from: now)
        lastUsed.hour = calender.component(.hour, from: now)
        lastUsed.minute = calender.component(.minute, from: now)
        lastUsed.second = calender.component(.second, from: now)
    }
    
    func getLastUseStr(prescript: String = "", postscript: String = "") -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let diffYear = calendar.component(.year, from: now) - lastUsed.year! //Fatal Error: Unexpectedly found nil while unwrapping Optional value lastUsed
        if(diffYear >= 1) {
            return ("\(prescript)\(diffYear) years\(postscript)")
        }
        
        let diffMonth = calendar.component(.month, from: now) - lastUsed.month!
        if(diffMonth >= 1) {
            return ("\(prescript)\(diffMonth) months\(postscript)")
        }
        
        let diffDay = calendar.component(.day, from: now) - lastUsed.day!
        if(diffDay >= 1) {
            return ("\(prescript)\(diffDay) days\(postscript)")
        }
        
        let diffHour = calendar.component(.hour, from: now) - lastUsed.hour!
        if(diffHour >= 1) {
            return ("\(prescript)\(diffHour) hours\(postscript)")
        }
        
        let diffMin = calendar.component(.minute, from: now) - lastUsed.minute!
        return ("\(prescript)\(diffMin) min\(postscript)")
    }
}
