//
//  SearchTableViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 6/11/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit
import CoreLocation

class SearchTableViewController: UITableViewController {
    var searchInputStr : String?
    var currCoordinates : CLLocationCoordinate2D?
    var searchRestaurants : [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inputStr = searchInputStr {
            if let latitude = currCoordinates?.latitude {
                if let longitude = currCoordinates?.longitude {
                    let callStr = getBusinessCustomSearchCall(searchInput: inputStr, latitude: latitude, longitude: longitude)
                    print("getBusinessCustomSearchCall returned with callStr: \(callStr)")
                    getRestaurantsAndUpdateTV(YelpAPIString: callStr)
                }
                else {
                    print("ERROR unwrapping longitude after segue from MasterVC to SearchVC")
                }
            }
            else {
                print("ERROR unwrapping latitude after segue from MasterVC to SearchVC")
            }
        }
        else {
            print("ERROR unwrapping searchInputStr after segue from MasterVC to SearchVC")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleOneDealForOneRestaurant(restaurant: Restaurant, restIndex: Int, deal: Deal) {
        print("inside handleOneDealForOneRestaurant")
        restaurant.deals.append(deal)
        print("   adding new deal \(deal.shortDescription) to restaurant \(restaurant.name) now with \(restaurant.deals.count) deals:")
        
        let thisCellPath = IndexPath(row: restIndex, section: 0)
        
        DispatchQueue.main.async {
            self.setCellDeals(restName: restaurant.name, deal: deal, cellPath: thisCellPath, whichDeal: restaurant.deals.count - 1)
            self.searchRestaurants.sort(by: {$0.deals.count > $1.deals.count})
            self.tableView.reloadData()
        }
    }
    
    func handleDealsForOneRestaurant(restaurant: Restaurant, restIndex: Int, deals: [String]) {
        print("inside handleDealsForOneRestaurant")
        for deal in deals {
            dbGetDealWithID(id: deal, restID: restaurant.id) {
                newDeal in
                
                if let newDeal = newDeal {
                    self.handleOneDealForOneRestaurant(restaurant: restaurant, restIndex: restIndex, deal: newDeal)
                }
            }
        }
    }
    
    func getRestaurantsAndUpdateTV(YelpAPIString: String) {
        print("inside getRestaurantsAndUpdateTV")
        Restaurant.getRestaurantsFromSearch(apiYelpURL: YelpAPIString) {
            completedRestaurants in
            for (restIndex, restaurant) in completedRestaurants.enumerated() {
                //for each deal, add to array
                dbUpdateRestaurantWithDeals(restaurant: restaurant) {
                    deals in
                    if let deals = deals {
                        self.handleDealsForOneRestaurant(restaurant: restaurant, restIndex: restIndex, deals: deals)
                    }
                }
                
                restaurant.printRestaurant()
                
                if self.searchRestaurants.contains(restaurant) {
                    print("restaurant \(restaurant.name) already in array")
                }
                else {
                    self.searchRestaurants.append(restaurant)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRestaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchRestaurantCell", for: indexPath) as? SearchRestaurantTableViewCell
        let rest = searchRestaurants[indexPath.row]
        
        cell?.nameLabel?.text = rest.name
        cell?.locationLabel?.text = rest.locationStr
        cell?.priceLabel?.text = rest.priceDict[rest.price]
        cell?.tagsLabel?.text = rest.tags.joined(separator: ", ")

        // if no image URL is specified, use default text; otherwise, load image icon (first one)!
        if rest.images.count > 0 {
            cell?.imgLabel.isHidden = true
            cell?.restImageView.isHidden = false
            
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: URL(string: rest.images[0])!) {
                    DispatchQueue.main.async {
                        cell?.restImageView.image = UIImage(data: imageData)
                    }
                }
                else {
                    print("img url failed to unwrap for \(rest.images[0])")
                    DispatchQueue.main.async {
                        cell?.restImageView.isHidden = true
                        cell?.imgLabel.isHidden = false
                        cell?.imgLabel?.text = "no img"
                    }
                }
            }
        }
        else {
            cell?.restImageView.isHidden = true
            cell?.imgLabel.isHidden = false
            cell?.imgLabel?.text = "no img"
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
            //            print("currently no deals in \(rest.name): \(rest.deals.count)")
            cell?.deal1Label?.text = "currently no deals"
            cell?.deal2Label?.text = "currently no deals"
            cell?.deal1TimeLabel?.text = ""
            cell?.deal2TimeLabel?.text = ""
        }

        return cell!
    }
    
    func setCellDeals(restName: String, deal: Deal, cellPath: IndexPath, whichDeal: Int) {
        let cell = tableView.cellForRow(at: cellPath) as? RestaurantTableViewCell
        
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


    // MARK: - Navigation
    
    @IBAction func unwindFromDetailsVCToSearchVC(sender: UIStoryboardSegue) {
        if let senderVC = sender.source as? DetailsViewController {
            if senderVC.didEditRestaurant {
                let editedRestaurant = senderVC.restaurant
                
                if let index = senderVC.restaurantIndex {
                    let restaurantIndex: Int = index.section + index.row
                    
                    searchRestaurants[restaurantIndex] = editedRestaurant!
                    tableView.reloadRows(at: [IndexPath(row: senderVC.restaurantIndex!.row, section: 0)], with: .automatic)
                }
                else {
                    searchRestaurants.sort(by: {$0.deals.count > $1.deals.count})
                    tableView.reloadData()
                }
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVC" {
            let destVC = segue.destination as? DetailsViewController
            destVC?.senderAlias = "search"
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                destVC?.restaurant = searchRestaurants[selectedIndexPath.row]
                destVC?.restaurantIndex = selectedIndexPath
            }
            
            
        }
    }

}
