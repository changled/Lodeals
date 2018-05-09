//
//  DetailsViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: -- SET UP
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
//    @IBOutlet weak var dealLabel: UILabel!
//    @IBOutlet weak var lastUsedLabel: UILabel!
//    @IBOutlet weak var verifyButtonLabel: UIButton!
    @IBOutlet weak var dealTableView: UITableView!
    
    var restaurant : Restaurant?
//    var dealIsVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = restaurant?.name
        priceLabel.text = restaurant?.priceDict[(restaurant?.price)!]
        addressLabel.text = restaurant?.location
        tagsLabel.text = restaurant?.tags.joined(separator: ", ")
        imageLabel.text = restaurant?.image
//        dealLabel.text = restaurant?.deals[0].shortDescription
//        lastUsedLabel.text = restaurant?.deals[0].getLastUseStr(prescript: "...")
//        verifyButtonLabel.titleLabel = "Verify!"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -- TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant!.deals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as? DealTableViewCell
        let thisDeal = restaurant?.deals[indexPath.row]
        print(thisDeal?.shortDescription ?? "none")
        
        cell?.shortDescriptionLabel?.text = thisDeal?.shortDescription
        cell?.lastUsedLabel?.text = thisDeal?.getLastUseStr(prescript: "...")
        cell?.verifyButton?.tag = indexPath.row
        cell?.verifyButton?.addTarget(self, action: #selector(DetailsViewController.verifyAction(_:)), for: .touchUpInside)
//        cell?.verifyButton?.target(forAction: Selector("verifyAction:"), withSender: .touchUpInside)
        
        return cell!
    }
    
    //verified: blue background color, black text, "Verified" title
    //unverified: white background color, blue text, "Verify" title
    @IBAction func verifyAction(_ sender: UIButton) {
        let bool = !(restaurant?.deals[sender.tag].dealIsVerified)!
        restaurant?.deals[sender.tag].dealIsVerified = bool
        
        let bgColor = bool ? self.view.tintColor : .white
        let titleTxt = bool ? "Verified" : "Verify"
        let titleColor = bool ? .white : self.view.tintColor
        
        sender.setTitle(titleTxt, for: .normal)
        sender.setTitleColor(titleColor, for: .normal)
        sender.backgroundColor = bgColor
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
