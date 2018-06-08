//
//  yelpApiFunctions.swift -> yelpFunctions
//  Lodeals
//
//  Created by Rachel Chang on 5/30/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation

/*
 * Takes in a struct of type YelpServiceBusinessSearchWithKeyword (which contains "total" and "businesses", an array of structs of type YelpServiceBusiness)
 * This function loops through either all businesses in the array or the maxCount (set to 23 as default), whichever comes first
 * Within the for loop, assign variables to be used in the instantiation of a Restaurant class
 * These objects are appended to an array of Restaurants, then returned at the end
 */
func getRestaurantsFromStruct(businesses: YelpServiceBusinessSearchWithKeyword, maxCount: Int = 23) -> [Restaurant] {
    var restaurants = [Restaurant]()
    var count = 0
    
    for business in businesses.businesses! {
        let name = business.name
        let location = "\(business.location.address1), \(business.location.city), \(business.location.state), \(business.location.zip_code)"
        let priceStr = business.price
        let id = business.id
        let alias = business.alias
        let longitude = business.coordinates.longitude
        let latitude = business.coordinates.latitude
        
        var tags: [String] = []
        
        for category in business.categories {
            tags.append(category.title)
        }
        
        let restaurant = Restaurant(name: name, id: id, location: location, images: [business.image_url!], tags: tags, priceStr: priceStr, alias: alias, longitude: longitude, latitude: latitude)
        
//        // update images if present
//        let imageIcon = business.image_url
//        if imageIcon != nil {
//            restaurant.images = [imageIcon!]
//        }
        
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

