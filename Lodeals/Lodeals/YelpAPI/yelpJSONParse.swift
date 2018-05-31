//
//  yelpJSONParse.swift -> yelpStructs
//  
//
//  Created by Rachel Chang on 5/30/18.
//

import Foundation

struct TxtYelpService : Codable {
    let terms : [TxtText]
    
    struct TxtText : Codable {
        var text : String
    }
}

struct TxtYelpServiceBusiness : Codable {
    var price: String
    var id: String
    var review_count: Int
    var name: String
    var rating: Int
    var url: String
}

struct YelpServiceBusinessSearchWithKeyword : Codable {
    var total: Int?
    var businesses: [YelpServiceBusiness]?
}

struct YelpServiceBusiness : Codable {
    var price: String
    var id: String
    var alias: String
    var categories: [YelpServiceCategory]
    var review_count: Int
    var name: String
    var url: String
    var coordinates: YelpServiceCoordinates
    var image_url: String?
    var location: YelpServiceLocation
    var phone: String?
    var photos: [String]?
    var rating: Float

    func printBusiness() {
        print("\(name) --")
        print("\t id: \(String(describing: id))")
        print("\t alias: \(String(describing: alias))")
        print("\t rating: \(String(describing: rating))")
        print("\t price: \(String(describing: price))")
        print("\t categories: \(String(describing: categories))")
        print("\t review count: \(String(describing: review_count))")
        print("\t url: \(String(describing: url))")
        print("\t image_url: \(String(describing: image_url))")
        print("\t coordinates: (\(String(describing: coordinates.longitude)), \(String(describing: coordinates.latitude))")
    }
}

struct YelpServiceCategory : Codable {
    var alias: String
    var title: String
}

struct YelpServiceCoordinates : Codable {
    var latitude: Double
    var longitude: Double
}

struct YelpServiceLocation : Codable {
    var city: String
    var country: String
    var address2: String?
    var address3: String?
    var state: String
    var address1: String
    var zip_code: String
}

