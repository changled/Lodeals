//
//  MainViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved. prototype branch
//  My Yelp API Key: qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx
// SLO Address Coordinates: 35.300499, -120.677059

import UIKit
import GoogleMaps
import YelpAPI
import BrightFutures

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: -- SET UP
    
    var restaurants = [Restaurant]()
    var twentyRestaurants = [Restaurant]()
    var locationManager = CLLocationManager()
    var businessesFromYelp : [Business]!
    @IBOutlet weak var restaurantTV: UITableView!
    var businessStruct: TxtYelpServiceBusiness?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurants = preAddRestaurants()
        print ("\n\nIN MASTER CONTROLLER!!")
        let apiYelpURL = getBusinessLocationSearchCall(longitude: -120.677059, latitude: 35.300499)
        OHORestaurant.getRestaurants(apiYelpURL: apiYelpURL) {
            resttt in
            for restau in resttt {
                print("hello!")
                restau.printRestaurant()
            }
        }
        twentyRestaurants = makeBusinessSearchCall(apiYelpURL: apiYelpURL)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -- UNWIND
    
    @IBAction func unwindFromDetailsVC(sender: UIStoryboardSegue) {
        if sender.source is DetailsViewController {
            if let senderVC = sender.source as? DetailsViewController {
                let editedRestaurant = senderVC.restaurant
                let restaurantIndex: Int = senderVC.restaurantIndex!.section + senderVC.restaurantIndex!.row
                
                restaurants[restaurantIndex] = editedRestaurant!
             }
            
            restaurantTV.reloadData()
        }
    }
    
    // MARK: -- TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainSceneRestaurantCell", for: indexPath) as? RestaurantTableViewCell
        let rest = restaurants[indexPath.row]
        
        cell?.nameLabel?.text = rest.name
        cell?.locationLabel?.text = rest.location
        cell?.imageLabel?.text = rest.images[0]
        cell?.priceLabel?.text = rest.priceDict[rest.price]
        cell?.tagsLabel?.text = rest.tags.joined(separator: ", ")
        cell?.deal1Label?.text = rest.deals[0].shortDescription
        cell?.deal1TimeLabel?.text = rest.deals[0].getLastUseStr(prescript: "...", postscript: " ago")
        
        if(rest.deals.count > 1) {
            cell?.deal2Label?.text = rest.deals[1].shortDescription
            cell?.deal2TimeLabel?.text = rest.deals[1].getLastUseStr(prescript: "...", postscript: " ago")
        }
        
        return cell!
    }

    // MARK: - NAVIGATION

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\n\n     (in prepare for segue) BUSINESS STRUCT ---- ")
        print(twentyRestaurants.count)
//        for restau in twentyRestaurants {
//            print("hello!")
//            restau.printRestaurant()
//        }
        
//        print("price : \(self.businessStruct?.price ?? "na price")")
//        print("id : \(self.businessStruct?.id ?? "no id")")
//        print("name : \(self.businessStruct?.name ?? "no name")")

        if(segue.identifier == "showDetailsVC") {
            let destVC = segue.destination as? DetailsViewController
            let selectedIndexPath = restaurantTV.indexPathForSelectedRow
            
            destVC?.restaurant = restaurants[(selectedIndexPath?.row)!]
            destVC?.restaurantIndex = selectedIndexPath
        }
        
        if(segue.identifier == "showMapVC") {
            print("preparing for segue")
        }
    }

}
