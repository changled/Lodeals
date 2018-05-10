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
    @IBOutlet weak var dealTableView: UITableView!
    
    var restaurant : Restaurant?
    var restaurantIndex : IndexPath?
    var dealIsExpanded : [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = restaurant?.name
        priceLabel.text = restaurant?.priceDict[(restaurant?.price)!]
        addressLabel.text = restaurant?.location
        imageLabel.text = restaurant?.image
        resetExpansionToFalse()
        
        tagsLabel.text = restaurant?.tags.joined(separator: ", ")
        setLabelFrame(origin: CGPoint(x: 28, y: 163), label: tagsLabel, maxWidth: 357)
    }
    
    // stretch to fit label text with width constraints
    func setLabelFrame(origin: CGPoint, label: UILabel, maxWidth: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 17.0)) {
        let dynamicHeight = label.text?.height(withConstrainedWidth: CGFloat(maxWidth), font: font)
        let labelSize = CGSize(width: maxWidth, height: dynamicHeight!)
        tagsLabel.frame = CGRect(origin: origin, size: labelSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resetExpansionToFalse() {
        for _ in (restaurant?.deals)! {
            dealIsExpanded.append(false)
        }
    }
    
    // MARK: -- UNWIND
    
    @IBAction func unwindCancelFromConfirmAddDealVC(sender: UIStoryboardSegue) {
    }
    
    @IBAction func unwindSaveFromConfirmAddDealVC(sender: UIStoryboardSegue) {
        if sender.source is ConfirmAddDealViewController {
            if let senderVC = sender.source as? ConfirmAddDealViewController {
                let dealTitle = senderVC.dealTitle
                let dealDescription = senderVC.dealDescription
                
                let newDeal = Deal(shortDescription: dealTitle!, description: dealDescription!, lastUsed: nil)
                
                newDeal.dealIsVerified = true
                newDeal.updateLastUsedToNow()
                
                restaurant?.deals.append(newDeal)
                resetExpansionToFalse()
                dealIsExpanded.append(true)
                dealTableView.reloadData()
            }
        }
    }
    
    // MARK: -- TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return restaurant!.deals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !dealIsExpanded[section] {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.TapGestureRecognizer(gestureRecognizer:)))
//        tableView.addGestureRecognizer(tapGesture)
        
        let button = UIButton(type: .system)
        button.setTitle(restaurant?.deals[section].shortDescription, for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
//
//    @objc func TapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
//        //do your stuff here
//        print("tapped")
//    }

    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        let indexPath = IndexPath(row: 0, section: section)
        indexPaths.append(indexPath)
        
        let isExpanded = dealIsExpanded[section]
        dealIsExpanded[section] = !isExpanded
        
        if isExpanded {
            dealTableView.deleteRows(at: indexPaths, with: .fade)
        }
        else {
            dealTableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as? DealTableViewCell
        let thisDeal = restaurant?.deals[indexPath.section]
        
//        print(thisDeal?.description.height(withConstrainedWidth: CGFloat(179), font: UIFont.systemFont(ofSize: 17.0)) as Any) //calculates minimum height given the width and text
        //width: 357
        
        cell?.shortDescriptionLabel?.sizeToFit()
        cell?.shortDescriptionLabel?.text = thisDeal?.description
        cell?.lastUsedLabel?.text = thisDeal?.getLastUseStr(prescript: "...")
        cell?.verifyButton?.tag = indexPath.section
        cell?.verifyButton?.addTarget(self, action: #selector(DetailsViewController.verifyAction(_:)), for: .touchUpInside)
        setButton(isVerified: (thisDeal?.dealIsVerified)!, butt: (cell?.verifyButton)!)
        
        return cell!
    }
    
    @IBAction func verifyAction(_ sender: UIButton) {
        let bool = !(restaurant?.deals[sender.tag].dealIsVerified)!
        restaurant?.deals[sender.tag].dealIsVerified = bool
        
        setButton(isVerified: bool, butt: sender)
        dealTableView.reloadData()
    }
    
    //verified: blue background color, black text, "Verified" title
    //unverified: white background color, blue text, "Verify" title
    func setButton(isVerified: Bool, butt: UIButton) {
        let bgColor = isVerified ? self.view.tintColor : .white
        let titleTxt = isVerified ? "Verified" : "Verify"
        let titleColor = isVerified ? .white : self.view.tintColor
        
        butt.setTitle(titleTxt, for: .normal)
        butt.setTitleColor(titleColor, for: .normal)
        butt.backgroundColor = bgColor
    }
    
    // MARK: -- UNWIND
    @IBAction func goBackToOneButtonTapped(_sender: Any) {
        performSegue(withIdentifier: "unwindSegueToMasterVC", sender: self)
    }
    
    // MARK: -- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAddDealVC") {
            let destVC = segue.destination as? AddDealViewController
            destVC?.restaurant = restaurant
        }
    }

}
