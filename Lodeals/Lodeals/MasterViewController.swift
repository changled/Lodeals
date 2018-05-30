//
//  MainViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved. prototype branch
//

import UIKit
import GoogleMaps
import YelpAPI
import BrightFutures

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: -- SET UP
    
    var restaurants = [Restaurant]()
    var locationManager = CLLocationManager()
    var businessesFromYelp : [Business]!
    @IBOutlet weak var restaurantTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurants = preAddRestaurants()
        
//        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
//
//            self.businesses = businesses
//            if let businesses = businesses {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
//            }
//        })
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
