//
//  MainViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved. prototype branch
//  My Yelp API Key: qQJmRKBK0HOd7E4mBxhhUXaeKEotiUOqkuN3G3mrPM4fvsUdM_RkJc86_5ah25aW6V_4Ke_53wsbG1b8VtFx2AZo_gV1r-5dDMriM-guhV_UC1iorPTNosXGvir-WnYx
// SLO Address Coordinates: latitude=35.300499, longitude=-120.677059
// TO-DO: How can I add a toolbar above the keyboard

import UIKit
import GoogleMaps
import CoreLocation

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    
//    MARK: -- SET UP
    
    var restaurants = [Restaurant]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var businessesFromYelp : [Business]!
    @IBOutlet weak var restaurantTV: UITableView!
    var businessStruct: TxtYelpServiceBusiness?
    let aptLatitude = 35.300499
    let aptLongitude = -120.677059
    var currCoordinates : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if touch anywhere outside of text field
        self.hideKeyboardWhenTappedAround()
        
//        restaurants = preAddRestaurants()
//        let apiYelpURL = getBusinessLocationSearchCall(longitude: -120.677059, latitude: 35.300499)
//        currCoordinates = CLLocationCoordinate2D(latitude: aptLatitude, longitude: aptLongitude)
        
        // get user location and use to make yelp business location search call
        self.getUserLocation()
        let apiYelpURL = getBusinessLocationSearchCall(longitude: currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude)
        currCoordinates = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        
        // Get instantiations of Restaurant class from API call determined by apiYelpURL and asynchronously update TV
        Restaurant.getRestaurantsFromSearch(apiYelpURL: apiYelpURL) {
            completedRestaurants in
            for (restIndex, restaurant) in completedRestaurants.enumerated() {
                //for each deal, add to array
                dbUpdateRestaurantWithDeals(restaurant: restaurant) {
                    deals in
                    
                    if let deals = deals {
                        for deal in deals {
                            dbGetDealWithID(id: deal, restID: restaurant.id) {
                                newDeal in
                                
                                if let newDeal = newDeal {
                                    restaurant.deals.append(newDeal)
                                    print("   adding new deal \(newDeal.shortDescription) to restaurant \(restaurant.name) now with \(restaurant.deals.count) deals:")
                                    
                                    let thisCellPath = IndexPath(row: restIndex, section: 0)
                                    
                                    DispatchQueue.main.async {
                                        self.setCellDeals(restName: restaurant.name, deal: newDeal, cellPath: thisCellPath, whichDeal: restaurant.deals.count - 1)
                                        self.restaurants.sort(by: {$0.deals.count > $1.deals.count})
                                        self.restaurantTV.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
                
                restaurant.printRestaurant()
                self.restaurants.append(restaurant)
            }
            
            DispatchQueue.main.async {
                self.restaurantTV.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    MARK: -- UNWIND
    
    @IBAction func unwindFromDetailsVC(sender: UIStoryboardSegue) {
        if sender.source is DetailsViewController {
            if let senderVC = sender.source as? DetailsViewController {
                let editedRestaurant = senderVC.restaurant
                
                if let index = senderVC.restaurantIndex {
                    let restaurantIndex: Int = index.section + index.row
                
                    restaurants[restaurantIndex] = editedRestaurant!
                    restaurantTV.reloadRows(at: [IndexPath(row: senderVC.restaurantIndex!.row, section: 0)], with: .automatic)
                }
                else {
                    print("NOTE: TEST IF CORRECT -- returning from a map view -> details vc!")
                    restaurantTV.reloadData()
                    // NOTE: TEST THAT IT'S ACTUALLY SAVING AND RELOADING CORRECT DATA!
                }
             }
        }
    }
    
//    MARK: -- OTHER UI
    
    // sets text field's didEndEditing to true and close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            
            currentLocation = locationManager.location
        }
    }
    
//    MARK: -- TABLE VIEW
    
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
        cell?.locationLabel?.text = rest.locationStr
        cell?.priceLabel?.text = rest.priceDict[rest.price]
        cell?.tagsLabel?.text = rest.tags.joined(separator: ", ")
        
        // if no image URL is specified, use default text; otherwise, load image icon (first one)!
        if rest.images.count > 0 {
            cell?.imageLabel.isHidden = true
            cell?.iconImageView.isHidden = false
            
            DispatchQueue.global().async {
                let imageData = try? Data(contentsOf: URL(string: rest.images[0])!)
                
                DispatchQueue.main.async {
                    cell?.iconImageView.image = UIImage(data: imageData!)
                }
            }
        }
        else {
            cell?.iconImageView.isHidden = true
            cell?.imageLabel.isHidden = false
            cell?.imageLabel?.text = "no img"
        }
        
        // default to "currently no deals" if no deals fewer than 2 deals
        if rest.deals.count > 0 { // at least one deal
            cell?.deal1Label?.text = rest.deals[0].shortDescription
            cell?.deal1TimeLabel?.text = rest.deals[0].getLastUseStr(prescript: "...", postscript: " ago")

            if(rest.deals.count > 1) { //at least 2 deals
                cell?.deal2Label?.text = rest.deals[1].shortDescription
                cell?.deal2TimeLabel?.text = rest.deals[1].getLastUseStr(prescript: "...", postscript: " ago")
            }
            else { //only one deal
                cell?.deal2Label?.text = "only one deal -- another!"
                cell?.deal2TimeLabel?.text = ""

            }
        }
        else { // no deals
            print("currently no deals in \(rest.name): \(rest.deals.count)")
            cell?.deal1Label?.text = "currently no deals"
            cell?.deal2Label?.text = "currently no deals"
            cell?.deal1TimeLabel?.text = ""
            cell?.deal2TimeLabel?.text = ""
        }
        
        return cell!
    }
    
    func setCellDeals(restName: String, deal: Deal, cellPath: IndexPath, whichDeal: Int) {
        let cell = restaurantTV.cellForRow(at: cellPath) as? RestaurantTableViewCell
        
        // default to "currently no deals" if no deals fewer than 2 deals
        if whichDeal == 0 { // setting first deal label in cell
            print("setting \(restName)'s first deal to \(deal.shortDescription)")
            cell?.deal1Label?.text = deal.shortDescription
            cell?.deal1TimeLabel?.text = deal.getLastUseStr(prescript: "...", postscript: " ago")
            cell?.deal2Label?.text = "only one deal -- add another!"
            cell?.deal2TimeLabel?.text = ""
        }
        else if whichDeal == 1 { // setting second deal label in cell
            cell?.deal2Label?.text = deal.shortDescription
            cell?.deal2TimeLabel?.text = deal.getLastUseStr(prescript: "...", postscript: " ago")
        }
    }

//    MARK: - NAVIGATION

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailsVC") {
            let destVC = segue.destination as? DetailsViewController
            let selectedIndexPath = restaurantTV.indexPathForSelectedRow
 
            destVC?.restaurant = restaurants[(selectedIndexPath?.row)!]
            destVC?.restaurantIndex = selectedIndexPath
        }
        
        if(segue.identifier == "showMapVC") {
            print("preparing for map segue: currently doing nothing to prepare")
        }
        
        if(segue.identifier == "showAppleMapVC") {
            let destVC = segue.destination as? AppleMapViewController
            
            destVC?.restaurants = restaurants
            destVC?.searchLocation = currCoordinates
        }
    }
}
