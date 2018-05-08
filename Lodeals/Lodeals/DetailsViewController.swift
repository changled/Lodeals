//
//  DetailsViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var lastUsedLabel: UILabel!
    @IBOutlet weak var verifyButtonLabel: UIButton!
    
    var restaurant : Restaurant?
    var dealIsVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameLabel.text = restaurant?.name
        priceLabel.text = restaurant?.priceDict[(restaurant?.price)!]
        addressLabel.text = restaurant?.location
        tagsLabel.text = restaurant?.tags.joined(separator: ", ")
        imageLabel.text = restaurant?.image
        dealLabel.text = restaurant?.deals[0].shortDescription
        lastUsedLabel.text = restaurant?.deals[0].getLastUseStr(prescript: "...")
//        verifyButtonLabel.titleLabel = "Verify!"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func verifyDeal(_ sender: Any) {
        activateButton(bool: !dealIsVerified)
    }
    
    //if deal IS verified: background color is blue, text is black, title is "Verified"
    //if deal is NOT verified: background color is white, text is blue, title is "Verify"
    func activateButton(bool: Bool) {
        dealIsVerified = bool
        
        let bgColor = bool ? self.view.tintColor : .white
        let titleTxt = bool ? "Verified" : "Verify"
        let titleColor = bool ? .white : self.view.tintColor
        
        verifyButtonLabel.setTitle(titleTxt, for: .normal)
        verifyButtonLabel.setTitleColor(titleColor, for: .normal)
        verifyButtonLabel.backgroundColor = bgColor
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
