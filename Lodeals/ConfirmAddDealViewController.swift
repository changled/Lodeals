//
//  ConfirmAddDealViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/9/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
// USE TEXT FIELD INSTEAD of Label

import UIKit

class ConfirmAddDealViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    var dealTitle : String?
    var dealDescription : String?
    var restaurantName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view title; use "if let" so there's no optional '?' in the text
        if let viewTitle = restaurantName {
            self.navigationItem.title = "\(String(describing: viewTitle))"
        }

        titleLabel.text = dealTitle
        restaurantLabel.text = restaurantName
        
        descriptionLabel.textRect(forBounds: CGRect(x: descriptionLabel.center.x, y: descriptionLabel.center.y, width: descriptionLabel.frame.width, height: 0), limitedToNumberOfLines: 0)
        descriptionLabel.text = dealDescription
        descriptionLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */
}
