//
//  main.swift
//  
//
//  Created by Rachel Chang on 5/30/18.
//

//
//  main.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/30/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation
import YelpAPI
import BrightFutures

// Fill in your app keys here from
// www.yelp.com/developers/v3/manage_app
let appId = "qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx"
let appSecret = ""

// Search for 3 dinner restaurants
let query = YLPQuery(location: "San Francisco, CA")
query.term = "dinner"
query.limit = 3

YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
    client.search(withQuery: query)
    }.onSuccess { search in
        print("hello inside main.swift")
        if let topBusiness = search.businesses.first {
            print("Top business: \(topBusiness.name), id: \(topBusiness.identifier)")
        } else {
            print("No businesses found")
        }
        exit(EXIT_SUCCESS)
    }.onFailure { error in
        print("Search errored: \(error)")
        exit(EXIT_FAILURE)
}

dispatchMain()

