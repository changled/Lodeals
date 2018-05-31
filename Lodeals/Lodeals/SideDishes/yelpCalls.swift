//
//  yelpCalls.swift
//  
//
//  Created by Rachel Chang on 5/30/18.
//

import Foundation


// Given the coordinates (longitude and latitude), this function returns the HTTPS url used to make the API call with only location
// In the format of: https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972
func getBusinessLocationSearchCall(longitude: Double, latitude: Double) -> String {
    return "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)"
}

// due to the asynchronous nature of this, a callback is needed
class OHORestaurant {
    class func getRestaurants (apiYelpURL: String, completionHandler: @escaping (_ restaurants: [Restaurant]) -> ()) {
    //    var restaurants : [Restaurant] = []
        var theRestaurants: [Restaurant] = []
        var request = URLRequest(url: URL(string: apiYelpURL)!)
        request.addValue("Bearer qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx", forHTTPHeaderField: "Authorization") //my personal Yelp api key
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            if let data = receivedData {
                do {
                    let decoder = JSONDecoder()
                    let yelpServiceBusinessSearchWithKeyword = try decoder.decode(YelpServiceBusinessSearchWithKeyword.self, from: data)
                    print("YELP SERVICE BUSINESS SEARCH: \(yelpServiceBusinessSearchWithKeyword)")
                    theRestaurants = getRestaurantsFromStruct(businesses: yelpServiceBusinessSearchWithKeyword)
                    completionHandler(theRestaurants)
                } catch {
                    print("\nException on Decode: \(error)\n")
                }
            }
        }
        
        task.resume()
    }
}

func makeBusinessSearchCall(apiYelpURL: String) -> [Restaurant]? {
    var restaurants : [Restaurant] = []
    var request = URLRequest(url: URL(string: apiYelpURL)!)
    request.addValue("Bearer qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx", forHTTPHeaderField: "Authorization") //my personal Yelp api key
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
        if let data = receivedData {
            do {
                let decoder = JSONDecoder()
                let yelpServiceBusinessSearchWithKeyword = try decoder.decode(YelpServiceBusinessSearchWithKeyword.self, from: data)
                print("YELP SERVICE BUSINESS SEARCH: \(yelpServiceBusinessSearchWithKeyword)")
                restaurants = getRestaurantsFromStruct(businesses: yelpServiceBusinessSearchWithKeyword)
//                let businesses = yelpServiceBusinessSearchWithKeyword.businesses!
//                businesses[0].printBusiness()
            } catch {
                print("\nException on Decode: \(error)\n")
            }
        }
    }
    
    task.resume()
    return restaurants
}

// Print out the details of a speicific restaurant given the apiYelpURL
//    through a single business search using a unique identifier:
// apiYelpURL format: https://api.yelp.com/v3/businesses/north-india-restaurant-san-francisco"
func makeSingleBusinessCall(apiYelpURL: String) {
    var businessStruct: TxtYelpServiceBusiness?
    
    var request = URLRequest(url: URL(string: apiYelpURL)!)
    request.addValue("Bearer qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx", forHTTPHeaderField: "Authorization")
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
        if let data = receivedData {
            do {
                let decoder = JSONDecoder()
                businessStruct = try decoder.decode(TxtYelpServiceBusiness.self, from: data)
                print("     (in single business call func) BUSINESS STRUCT ---- ")
                print("price : \(businessStruct?.price ?? "no price")")
                print("id : \(businessStruct?.id ?? "no id")")
                print("name : \(businessStruct?.name ?? "no name")")
                print("url : \(businessStruct?.url ?? "no url")")
                print("review count : \(businessStruct?.review_count ?? -1)")
                print("rating : \(businessStruct?.rating ?? -1)")
            } catch {
                print("Exception on Decode: \(error)")
            }
        }
    }
    task.resume()
}
