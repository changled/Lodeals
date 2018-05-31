//
//  yelpApiFunctions.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/30/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation

func getRestaurantsFromStruct(businesses: YelpServiceBusinessSearchWithKeyword, maxCount: Int = 10) -> [Restaurant] {
    var restaurants = [Restaurant]()
    var count = 0
    print("\nIN GETRESTAURANTSFROMSTRUCT")
    
    for business in businesses.businesses! {
        let name = business.name
//        print(name)
        let location = "\(business.location.address1), \(business.location.city), \(business.location.state), \(business.location.zip_code)"
        let priceStr = business.price
        let id = business.id
        
        var tags: [String] = []
        
        for category in business.categories {
            tags.append(category.title)
        }
        
        let restaurant = Restaurant(name: name, id: id, location: location, tags: tags, priceStr: priceStr)
//        restaurant.printRestaurant()
        restaurants.append(restaurant)
        
        count += 1
        
        if count >= maxCount {
            print("\nINSIDE GET RESTAURANTS FROM STRUCT: \(restaurants.count)")
            return restaurants
        }
    }
    
    print("\nINSIDE GET RESTAURANTS FROM STRUCT: \(restaurants.count)")
    
    return restaurants
}
