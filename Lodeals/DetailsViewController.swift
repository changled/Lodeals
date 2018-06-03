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
    var lastlastUsed : [DateComponents] = []
    let imageXSpacingDict : [Int : CGFloat] = [0: 28, 1: 118, 2: 208, 3: 298]
    var images : [UIImageView] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = restaurant?.name
        priceLabel.text = restaurant?.priceDict[(restaurant?.price)!]
        addressLabel.text = restaurant?.locationStr
        
        tagsLabel.text = restaurant?.tags.joined(separator: ", ")
        setLabelFrame(origin: CGPoint(x: 28, y: 163), label: tagsLabel, maxWidth: 357)
        
        imageLabel.isHidden = true
        resetExpansionToFalse()
        print("\n\tINSIDE DETAILSVC")
        
        // just temporarily check alias against "" to be able to handle hard-coded restaurants
        if restaurant?.alias != "" {
            Restaurant.getBusinessDetails(restaurant: restaurant!) {
                completedRestaurant in
                self.restaurant?.printRestaurantDetails()
                self.loadImages()
            }
        }
    }
    
    // MARK: -- IMAGE HANDLING
    
    /*
     * Simply use CGRect() initializer to set x, y, width, and height values:
     *     x -- use the imageXSpacingDict dictionary with index % 4 to determine how far from left
     *     y -- use tagsLabel's y value + its height + 8 for buffer
     *     width -- 70
     *     height -- 70
     */
    func loadImages() {
        if let images = restaurant?.images {
            for (imgIndex, image) in images.enumerated() {
                if imgIndex >= 4 {
                    print("   BREAKING b/c index is: \(imgIndex)")
                    break
                }

                DispatchQueue.global().async {
                    let imageData = try? Data(contentsOf: URL(string: image)!)

                    DispatchQueue.main.async {
                        let xValue = self.imageXSpacingDict[imgIndex % 4]
                        let yValue = self.tagsLabel.frame.origin.y + self.tagsLabel.frame.size.height + 8 // add y-value to end of tags
                        let newImage = UIImageView(frame: CGRect(x: Int(xValue!), y: Int(yValue), width: 70, height: 70))
                        
                        newImage.image = UIImage(data: imageData!)
                        self.view.insertSubview(newImage, at: 0)
                    }
                }
            }
        }
        else {
            self.imageLabel.isHidden = false
        }
    }
    
    /*
     * Use NSLayoutConstraints to set:
     *     leading (x) constraint to the bottom of the tagsLabel + 8
     *     top (y) constraint to the left of tagsLabel
     *     width constraint to 70
     *     height constraint to 70
     * Then activate constraints
     */
    func loadImagesWithConstraints() {
        if let images = restaurant?.images {
            imageLabel.isHidden = true
            
            //temporarily set; do an expansion view upon tap later
            for (imgIndex, image) in images.enumerated() {
                if imgIndex >= 4 {
                    print("\nBREAKING OUT OF IMAGE LOADING B/C LIMIT REACHED\n")
                    break
                }
                print("for image: \(image)")
                
                let imageData = try? Data(contentsOf: URL(string: image)!)
                let newImage = UIImageView()
                newImage.image = UIImage(data: imageData!)
                self.view.insertSubview(newImage, at: 0)

                newImage.translatesAutoresizingMaskIntoConstraints = false
                
                let xValue = self.imageXSpacingDict[imgIndex % 4]
                let horizontalConstraint = NSLayoutConstraint(item: newImage, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: xValue!)
                let verticalConstraint = NSLayoutConstraint(item: newImage, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tagsLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8)
                let widthConstraint = NSLayoutConstraint(item: newImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 70)
                let heightConstraint = NSLayoutConstraint(item: newImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 70)

                NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            }
        }
    }
    
    // Used temporarily for testing/prototyping
    func loadBaebitionImages() {
        imageLabel.isHidden = true
        
        let gisView = UIImageView(frame: CGRect(x: 28, y: 210, width: 70, height: 70))
        let maiView = UIImageView(frame: CGRect(x: 118, y: 210, width: 70, height: 70))
        let crispyView = UIImageView(frame: CGRect(x: 208, y: 210, width: 70, height: 70))
        let rachView = UIImageView(frame: CGRect(x: 298, y: 210, width: 70, height: 70))
        
        gisView.image = UIImage(named: "gisScreenshot.png")
        maiView.image = UIImage(named: "maiScreenshot.png")
        crispyView.image = UIImage(named: "chrispyScreenshot.png")
        rachView.image = UIImage(named: "rachScreenshot.png")
        
        self.view.insertSubview(gisView, at: 0)
        self.view.insertSubview(maiView, at: 0)
        self.view.insertSubview(crispyView, at: 0)
        self.view.insertSubview(rachView, at: 1)
    }
    
    // stretch to fit label text with width constraints
    func setLabelFrame(origin: CGPoint, label: UILabel, maxWidth: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 17.0)) {
        let dynamicHeight = label.text?.height(withConstrainedWidth: CGFloat(maxWidth), font: font)
        let labelSize = CGSize(width: maxWidth, height: dynamicHeight!)
        tagsLabel.frame = CGRect(origin: origin, size: labelSize)
    }
    
    // MARK: -- UNWIND
    
    @IBAction func unwindCancelFromConfirmAddDealVC(sender: UIStoryboardSegue) {
    }
    
    // If the restaurant does not exist in the database, create a new one
    @IBAction func unwindSaveFromConfirmAddDealVC(sender: UIStoryboardSegue) {
        if sender.source is ConfirmAddDealViewController {
            if let senderVC = sender.source as? ConfirmAddDealViewController {
                let dealTitle = senderVC.dealTitle
                let dealDescription = senderVC.dealDescription
                
                let newDeal = Deal(shortDescription: dealTitle!, description: dealDescription!, lastUsed: nil)
                
                newDeal.dealIsVerified = true
                newDeal.updateLastUsedToNow()
                
                restaurant?.deals.append(newDeal)
                
                // use closure to determine what to do
                dbRestaurantExists(restaurant: restaurant!) {
                    restExists in
                    
                    if restExists {
                        print("\nREST EXISTS: JUST ADD NEW DEAL")
                    }
                    else {
                        print("\nREST DOESN'T YET EXIST: ADD NEW RESTAURANT")
                        dbInitAddRestaurant(restaurant: self.restaurant!)
                    }
                    
                    dbAddDeal(restaurant: self.restaurant!, deal: newDeal)
                }
                
                resetExpansionToFalse()
                dealIsExpanded.append(true)
                dealTableView.reloadData()
            }
        }
    }
    
    @IBAction func goBackToOneButtonTapped(_sender: Any) {
        performSegue(withIdentifier: "unwindSegueToMasterVC", sender: self)
    }
    
    // MARK: -- TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("\n\nDEALS COUNT FOR \(restaurant!.name): \(restaurant!.deals.count)")
        return restaurant!.deals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEAL IS EXPANDED COUNT: \(dealIsExpanded) versus section number \(section)")
        
        // check if dealsIsExpanded array is empty before trying to access inside it to fix fatal error
        if dealIsExpanded.count <= 0 || !dealIsExpanded[section] {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52 //set as the same as the UIView DealSectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dealHeaderView = DealSectionHeaderView()
        let thisDeal = restaurant?.deals[section]
        
        dealHeaderView.dealTitleLabel.text = thisDeal?.shortDescription
        dealHeaderView.lastUsedLabel.text = thisDeal?.getLastUseStr(prescript: "...")
        dealHeaderView.verifyButton?.tag = section
        dealHeaderView.verifyButton?.addTarget(self, action: #selector(DetailsViewController.verifyAction(_:)), for: .touchUpInside)
        setButton(isVerified: (thisDeal?.dealIsVerified)!, butt: (dealHeaderView.verifyButton)!)
        dealHeaderView.tag = section
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.TapGestureRecognizer(gestureRecognizer:)))
        dealHeaderView.addGestureRecognizer(tapGesture)
        
        return dealHeaderView
    }
    
    func resetExpansionToFalse() {
        for _ in (restaurant?.deals)! {
            dealIsExpanded.append(false)
        }
    }

    @objc func TapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        handleExpandClose(sender: gestureRecognizer)
    }

    @objc func handleExpandClose(sender: UIGestureRecognizer) {
        let section = sender.view?.tag
        
        var indexPaths = [IndexPath]()
        indexPaths = [IndexPath(row: 0, section: section!)]
        
        let isExpanded = dealIsExpanded[section!]
        dealIsExpanded[section!] = !isExpanded
        
        if isExpanded {
            dealTableView.deleteRows(at: indexPaths, with: .fade)
        }
        else {
            dealTableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as? DealTableViewCell
        let thisDeal = restaurant?.deals[indexPath.section]
        
//        print(thisDeal?.description.height(withConstrainedWidth: CGFloat(179), font: UIFont.systemFont(ofSize: 17.0)) as Any) //calculates minimum height given the width and text
        
        cell?.descriptionLabel?.sizeToFit()
        cell?.descriptionLabel?.text = thisDeal?.description
        
        return cell!
    }
    
    // MARK: -- VERIFY BUTTON
    
    @IBAction func verifyAction(_ sender: UIButton) {
        let bool = !(restaurant?.deals[sender.tag].dealIsVerified)!
        restaurant?.deals[sender.tag].dealIsVerified = bool
        
        //if just verified, set lastlastUsed in case if you unverify right away
        if bool {
            restaurant?.deals[sender.tag].lastlastUsed = (restaurant?.deals[sender.tag].lastUsed)!
            restaurant?.deals[sender.tag].updateLastUsedToNow()
        }
        else {
            restaurant?.deals[sender.tag].lastUsed = (restaurant?.deals[sender.tag].lastlastUsed)!
        }
        
        setButton(isVerified: bool, butt: sender)
        dealTableView.reloadData()
    }
    
    /*
     * Verified: blue background color, black text, "Verified" title
     * Unverified: white background color, blue text, "Verify" title
     */
    func setButton(isVerified: Bool, butt: UIButton) {
        let bgColor = isVerified ? self.view.tintColor : .white
        let titleTxt = isVerified ? "Verified" : "Verify"
        let titleColor = isVerified ? .white : self.view.tintColor
        
        butt.setTitle(titleTxt, for: .normal)
        butt.setTitleColor(titleColor, for: .normal)
        butt.backgroundColor = bgColor
    }
    
    // MARK: -- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAddDealVC") {
            let destVC = segue.destination as? AddDealViewController
            destVC?.restaurant = restaurant
        }
    }

}
