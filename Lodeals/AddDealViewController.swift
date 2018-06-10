//
//  AddDealViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/8/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class AddDealViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var titleLengthErrorLabel: UILabel!
    
    var didEditTitle = false
    var didEditDescription = false
    var restaurant : Restaurant?
    var dealTitle : String = ""
    var dealDescription : String = ""
    var validInput = [false, false]
    let alertVewMessageDict : [Int : String] = [0: "Deal title must be between 8 and 30 length\nDeal description must have at least 30 characters. Add more detail!", 1: "Deal title must be between 8 and 30 length", 2: "Deal description must have at least 30 characters. Add more detail!"]
    
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
    
    // MARK: - Navigation
    
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
                
                let alert = UIAlertController(title: "Error: Invalid input", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
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
