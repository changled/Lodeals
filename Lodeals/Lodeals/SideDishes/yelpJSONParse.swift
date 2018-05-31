//
//  yelpJSONParse.swift
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
}

////Put the API Key in the request header as "Authorization: Bearer <YOUR API KEY>".
////func setValue(String?, forHTTPHeaderField: String) Sets a value for a header field.
////var request = URLRequest(url: url)
////request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
////
////URLSession.shared.dataTask(with: request) { data, response, error in }
////request.httpMethod = "GET"
//
////
////  main.swift
////
////
////  Created by Rachel Chang on 5/30/18.
////
//
////
////  main.swift
////  Lodeals
////
////  Created by Rachel Chang on 5/30/18.
////  Copyright © 2018 Rachel Chang. All rights reserved.
////
//
//import Foundation
//import YelpAPI
//import BrightFutures
//
//print("INSIDE MAIN.SWIFT!!!")
//// Fill in your app keys here from
//// www.yelp.com/developers/v3/manage_app
//let appId = "qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx"
//let appSecret = ""
//
//let apiYelpURL = URL(string: "https://api.yelp.com/v3/autocomplete?text=del&latitude=37.786882&longitude=-122.399972")!
//let session = URLSession(configuration: URLSessionConfiguration.default)
//print("        AFTER LET SESSION")
//let request = URLRequest(url: apiYelpURL)
//var apiTxt: String?
//
//request.addValue("Bearer qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx", forHTTPHeaderField: "Authorization")
//
//
//URLSession.shared.dataTask(with: apiYelpURL) { data, response, error in
//    guard let data = data else { return }
//    print(data.count) //parse json data here
//    }.resume()
//
//
////
////let url = URL(string: "https://api.nicehash.com/api?method=stats.provider&addr=14FMY9XHC3eCvdGBvQz3a3pCwAeoar8VRz")!
////URLSession.shared.dataTask(with: url) { data, response, error in
////    guard let data = data else { return }
////    print(data.count) // you can parse your json data here
////    }.resume()
//
////let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
////    if let data = receivedData {
////        do {
////            let decoder = JSONDecoder()
////            let txtYelpService = try decoder.decode(TxtYelpService.self, from: data)
////            self.apiTxt = txtYelpService.terms.text
////        } catch {
////            print("Exception on Decode in main.swift: \(error)")
////        }
////    }
////}
////task.resume()
//
//
//
//// Search for 3 dinner restaurants
////let query = YLPQuery(location: "San Francisco, CA")
////query.term = "dinner"
////query.limit = 3
////
////YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
////    client.search(withQuery: query)
////    }.onSuccess { search in
////        print("hello inside main.swift")
////        if let topBusiness = search.businesses.first {
////            print("main.swift - Top business: \(topBusiness.name), id: \(topBusiness.identifier)")
////        } else {
////            print("main.swift - No businesses found")
////        }
////        exit(EXIT_SUCCESS)
////    }.onFailure { error in
////        print("main.swift - Search errored: \(error)")
////        exit(EXIT_FAILURE)
////}
////
////dispatchMain()
//
//
//
