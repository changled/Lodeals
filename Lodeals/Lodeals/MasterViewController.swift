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
        
        let deal1 = Deal(shortDescription: "BOGO chips", description: "Buy one bag of chips get one free", lastUsed: DateComponents(year: 1994, month: 12, day: 29, hour: 12, minute: 3))
        let deal2 = Deal(shortDescription: "$9 sandwiches", description: "After 4:20 pm, get any sandwich for $9", lastUsed: DateComponents(year: 2018, month: 5, day: 5, hour: 15, minute: 45))
        let rest = Restaurant(name: "High Street", location: "12490 Palmtag Dr.", tags: ["oh wow", "nice nice", "coo coo", "sandwiches", "American", "deli", "quick foods"], price: 2, deals: [deal1, deal2])
        restaurants.append(rest)
        
//        self.locationManager.delegate = self
//        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell?.deal2Label?.text = rest.deals[1].shortDescription
        cell?.deal2TimeLabel?.text = rest.deals[1].getLastUseStr(prescript: "...", postscript: " ago")
        
        return cell!
    }

    // MARK: - NAVIGATION

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailsVC") {
            let destVC = segue.destination as? DetailsViewController
            let selectedIndexPath = restaurantTV.indexPathForSelectedRow
            
            destVC?.restaurant = restaurants[(selectedIndexPath?.row)!]
        }
    }

}
