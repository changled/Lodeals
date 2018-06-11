//
//  AddDealViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/8/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class AddDealViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var titleLengthErrorLabel: UILabel!
    @IBOutlet weak var timesCollectionView: UICollectionView!
    
    var didEditTitle = false
    var didEditDescription = false
    var restaurant : Restaurant?
    var dealTitle : String = ""
    var dealDescription : String = ""
    var validInput = [false, false]
    let alertVewMessageDict : [Int : String] = [0: "Deal title must be between 8 and 30 length\nDeal description must have at least 30 characters. Add more detail!", 1: "Deal title must be between 8 and 30 length", 2: "Deal description must have at least 30 characters. Add more detail!"]
    let defaultOpenTimes = [[10, 21], [10, 21], [10, 21], [10, 21], [10, 23], [10, 23], [10, 23]]
//    let daysOfTheWeekDict : [String : Int] = ["Mon": 0, "Tue": 1, "Wed": 2, "Thur": 3, "Fri": 4, "Sat": 5, "Sun": 6]
    let daysOfTheWeekDict : [Int: String] = [0: "Mon", 1: "Tue", 2: "Wed", 3: "Thur", 4: "Fri", 5: "Sat", 6: "Sun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if touch anywhere outside of text view/text field
        self.hideKeyboardWhenTappedAround()
        
        // set view title; use "if let" so there's no optional '?' in the text
        if let viewTitle = restaurant?.name {
            self.navigationItem.title = "\(String(describing: viewTitle))"
        }
        
        titleLabel.text = ("Adding new deal for \(restaurant?.name ?? "null"):")
        titleTextField.addTarget(self, action: #selector(didChangeTitle(_:)), for: .editingChanged)
        titleLengthErrorLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -- TEXT FIELD (DEAL TITLE)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(!didEditTitle) {
            textField.text = ""
            didEditTitle = true
        }
    }
    
    @objc func didChangeTitle(_ textField: UITextField) {
        if let textLen = textField.text?.count {
            titleCountLabel.text = "\(30 - textLen)"
            
            if textLen <= 30 {
                dealTitle = textField.text!
                titleTextField.layer.borderColor = (UIColor.black).cgColor
                titleCountLabel.textColor = UIColor.lightGray
                titleLengthErrorLabel.text = ""
                if textLen > 8 {
                    validInput[0] = true
                    titleTextField.layer.borderColor = UIColor.green.cgColor
                }
                else {
                    titleTextField.layer.borderColor = UIColor.black.cgColor
                    validInput[0] = false
                }
            }
            else {
                titleTextField.layer.borderColor = (UIColor.red).cgColor
                titleCountLabel.textColor = UIColor.red
                titleLengthErrorLabel.text = "error: maxiumum 30 characters"
                validInput[0] = false
            }
        }
    }
    
    // sets text field's didEndEditing to true and close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: -- TEXT VIEW (DEAL DESCRIPTION)
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(!didEditDescription) {
            textView.text = ""
            didEditDescription = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        dealDescription = textView.text
        
        if dealDescription.count >= 30 {
            validInput[1] = true
            textView.layer.borderColor = UIColor.green.cgColor
        }
        else {
            textView.layer.borderColor = UIColor.black.cgColor
            validInput[1] = false
        }
    }
    
    @IBAction func clearAction(_ sender: Any) {
        titleTextField.text = ""
        descriptionTextView.text = ""
        didEditTitle = false
        didEditDescription = false
        validInput[1] = false
    }
    
    
//    MARK: -- COLLECTION VIEW
    
    // 7 sections = one section for each day of the week
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    /*
     *
     * ex. if self.defaultOpenTimes[section] == [10, 22], return 13 for 10, 11, 12, 1, 2, ... , 10
     *
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.defaultOpenTimes[section][1] - self.defaultOpenTimes[section][0] + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timesCVCell", for: indexPath) as? TimeCollectionViewCell
        
        var hourInt = self.defaultOpenTimes[indexPath.section][0] + indexPath.row
        
        if hourInt > 12 {
            hourInt = hourInt - 12
            cell?.timeButton.backgroundColor = UIColor.blue
        }
        else {
            cell?.timeButton.backgroundColor = UIColor.yellow
        }
        
        cell?.timeButton.setTitle("\(hourInt)", for: .normal)
        
        return cell!
    }
    
//    MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showConfirmAddDealVC" {
            if validInput != [true, true] {
                var alertMessage = ""
                
                if validInput[0] == false && validInput[1] == false {
                    alertMessage = alertVewMessageDict[0] ?? ""
                }
                else if validInput[0] == false {
                    alertMessage = alertVewMessageDict[1] ?? ""
                }
                else {
                    alertMessage = alertVewMessageDict[2] ?? ""
                }
                
                let alert = UIAlertController(title: "Error: Invalid length", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
                
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showConfirmAddDealVC") {
            let destVC = segue.destination as? ConfirmAddDealViewController
            
            destVC?.dealTitle = dealTitle
            destVC?.dealDescription = dealDescription
            destVC?.restaurantName = restaurant?.name
        }
    }
}
