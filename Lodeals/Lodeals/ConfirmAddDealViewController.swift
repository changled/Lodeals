//
//  ConfirmAddDealViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/9/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class ConfirmAddDealViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var dealTitle : String?
    var dealDescription : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = dealTitle
        descriptionLabel.text = dealDescription
//        print(descriptionLabel.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
