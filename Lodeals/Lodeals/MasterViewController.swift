//
//  MainViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit
import GoogleMaps

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: -- SET UP
    
    var restaurants = [Restaurant]()
    var dateFormatter = DateFormatter()
    var locationManager = CLLocationManager()
    @IBOutlet weak var restaurantTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let rest1deal1 = Deal(shortDescription: "BOGO chips", description: "Buy one bag of chips get one free", lastUsed: DateComponents(year: 2017, month: 12, day: 29, hour: 12, minute: 3))
        let rest1deal2 = Deal(shortDescription: "$9 sandwiches", description: "After 4:20 pm, get any sandwich for $9", lastUsed: DateComponents(year: 2018, month: 5, day: 5, hour: 15, minute: 45))
        let rest1 = Restaurant(name: "High Street", location: "12490 Palmtag Dr.", tags: ["oh wow", "nice nice", "coo coo", "sandwiches", "American", "deli", "quick foods"], price: 2, deals: [rest1deal1, rest1deal2])
        
        let rest2deal1 = Deal(shortDescription: "Free Birthday Burger", description: "Come in on your birthday with valid picture ID and get a 1/2 pound burger of your choice on us! Must allow us to photograph you in one of our crazy hats to validate.", lastUsed: DateComponents(year: 2018, month: 5, day: 2, hour: 7, minute: 38))
        let rest2deal2 = Deal(shortDescription: "THE BIG ONE Challenge", description: "THE BEEF!\nThe 5 pounds are broken down as follows:\n*2.5 POUND PATTY (post cook weight)\n*2.5 POUNDS of fixin's!\n\nSo... you can't tolerate the likes of onion, lettuce, pickle, or tomato?\nShame on you - but we will allow you to make THE BIG ONE any style on the menu! Whatever you don't like will be replaced with what you do like.\n5 POUNDS - NO ESCAPE!\n\nTHE RULES!:\n1. THE BIG ONE must be eaten by yourself. Friends can cheer - but they CAN'T CHEW!\n2.EVERYTHING served MUST be eaten in 30 minutes or less. SOP IT ALLLLL UP!\n3. Upon completion - you MUST hold down THE BIG ONE in your GUT for 1 full minute!\n\nAre you worthy?", lastUsed: DateComponents(year: 2018, month: 4, day: 20, hour: 12, minute: 4))
        let rest2deal3 = Deal(shortDescription: "$2 Pint Tuesdays", description: "Come in on Tuesdays and get a pint of beer for just $2 from our tap!", lastUsed: DateComponents(year: 2018, month: 5, day: 9, hour: 19, minute: 58))
        let rest2 = Restaurant(name: "Sylvester's Burgers", location: "1099 Santa Ynez Ave, Los Osos, CA 93402", tags: ["Burgers", "American (Traditional)", "Casual", "sandwiches", "American", "deli", "quick foods"], price: 1, deals: [rest2deal1, rest2deal2, rest2deal3])
        
        let rest3deal1 = Deal(shortDescription: "$2.50 Ninja Rolls", description: "On Mondays, get a Ninja Roll for just $2.50", lastUsed: DateComponents(year: 2018, month: 5, day: 7, hour: 20, minute: 26), dealIsVerified: true)
        let rest3deal2 = Deal(shortDescription: "10% off with Fremont Ticket", description: "Show us your fremont ticket (movie or concert) and get 10% off your meal! Only valid on the same day as your ticket.", lastUsed: DateComponents(year: 2017, month: 12, day: 29, hour: 12, minute: 3))
        let rest3deal3 = Deal(shortDescription: "$1.99 California Rolls", description: "On Tuesdays, get a California Roll for just $1.99", lastUsed: DateComponents(year: 2018, month: 5, day: 8, hour: 20, minute: 26))
        let rest3deal4 = Deal(shortDescription: "$2.99 Spicy Tuna Rolls", description: "On Wednesdays, get a Spicy Tuna Roll for just $2.99", lastUsed: DateComponents(year: 2018, month: 5, day: 9, hour: 20, minute: 26))
        let rest3deal5 = Deal(shortDescription: "$2.50 House Special Roll", description: "On Thursdays, get the House Special Roll for just $2.50", lastUsed: DateComponents(year: 2018, month: 5, day: 10, hour: 20, minute: 26))
        let rest3deal6 = Deal(shortDescription: "1/2 Off Sake", description: "On Fridays and Saturdays, get sake for 1/2 off the original price! Any size, any flavor.", lastUsed: DateComponents(year: 2018, month: 5, day: 5, hour: 20, minute: 26), dealIsVerified: true)
        let rest3deal7 = Deal(shortDescription: "$4.99 Chicken Teriyaki Bowl", description: "On Fridays and Saturdays, get a chicken teriyaki bowl for just $4.99. This deal is only valid through Joy Run deliveray app and not valid for in-house dining.", lastUsed: DateComponents(year: 2018, month: 5, day: 4, hour: 20, minute: 26))
        let rest3deal8 = Deal(shortDescription: "Pay Cash Get 10% Off", description: "Pay your entire bill with CASH and get 10% off.", lastUsed: DateComponents(year: 2018, month: 5, day: 10, hour: 20, minute: 26))
        let rest3deal9 = Deal(shortDescription: "$5.99 Poke Bowl", description: "On Sundays, get an original Tuna Poke Bowl for just $5.99. It comes with tuna poke, crabmeat, and seaweed salad on a rice bowl.", lastUsed: DateComponents(year: 2018, month: 5, day: 6, hour: 20, minute: 26))
        let rest3deal10 = Deal(shortDescription: "Jurors get 20% off", description: "Show us your juror badge and get 20% off.", lastUsed: DateComponents(year: 2018, month: 5, day: 6, hour: 20, minute: 26))
        let rest3 = Restaurant(name: "Aisuru Sushi", location: "1023 Monterey St, San Luis Obispo, CA 93401", tags: ["Sushi Bars", "Japanese", "Asian American Fusion"], price: 3, deals: [rest3deal1, rest3deal2, rest3deal3, rest3deal4, rest3deal5, rest3deal6, rest3deal7, rest3deal8, rest3deal9, rest3deal10])
        
        let rest4deal1 = Deal(shortDescription: "Love", description: "<3", lastUsed: DateComponents(year: 2018, month: 5, day: 7, hour: 20, minute: 26), dealIsVerified: true)
        let rest4deal2 = Deal(shortDescription: "Happiness", description: ":D", lastUsed: DateComponents(year: 2018, month: 5, day: 7, hour: 20, minute: 26), dealIsVerified: true)
        let rest4deal3 = Deal(shortDescription: "Family", description: "Except I don't want children. I don't get it", lastUsed: DateComponents(year: 2018, month: 5, day: 7, hour: 20, minute: 26), dealIsVerified: true)
//        let rest4deal4 = Deal(shortDescription: "Success", description: "A+", lastUsed: DateComponents(year: 2018, month: 5, day: 7, hour: 20, minute: 26))
        let rest4 = Restaurant(name: "BAEBITION", location: "Thugs Cottage", image: "<3", tags: ["Sexy", "Cute", "Smart", "Successful", "Fucking amazing", "420"], price: 4, deals: [rest4deal1, rest4deal2, rest4deal3])
        
        let rest5deal1 = Deal(shortDescription: "Nahhh", description: "Nahh", lastUsed: DateComponents(year: 2016, month: 5, day: 7, hour: 20, minute: 26))
        let rest5deal2 = Deal(shortDescription: "This place expensive as shit", description: "This place expensive as shit", lastUsed: DateComponents(year: 2016, month: 5, day: 7, hour: 20, minute: 26))
        let rest5 = Restaurant(name: "Ciopinot", location: "1051 Nipomo St, Steve's Guitar Shoppe, San Luis Obispo, CA 93401", tags: ["Seafood", "Fancy Restaurant"], price: 3, deals: [rest5deal1, rest5deal2])
        
        restaurants.append(rest1)
        restaurants.append(rest2)
        restaurants.append(rest3)
        restaurants.append(rest5)
        restaurants.append(rest4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -- UNWIND
    
    @IBAction func unwindFromDetailsVC(sender: UIStoryboardSegue) {
        print("unwind from DetailsVC")
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
        cell?.imageLabel?.text = rest.image
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
