//
//  ConfirmAddDealViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/9/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.

import UIKit

class ConfirmAddDealViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
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
        descriptionTextView.text = dealDescription
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
