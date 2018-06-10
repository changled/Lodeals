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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if touch anywhere outside of text view/text field
        self.hideKeyboardWhenTappedAround()
        
        // set view title; use "if let" so there's no optional '?' in the text
        if let viewTitle = restaurant?.name {
            self.navigationItem.title = "\(String(describing: viewTitle))"
        }
        
        titleLabel.text = ("New deal for \(restaurant?.name ?? "null"):")
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
            }
            else {
                titleTextField.layer.borderColor = (UIColor.red).cgColor
                titleCountLabel.textColor = UIColor.red
                titleLengthErrorLabel.text = "error: maxiumum 30 characters"
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
            
        }
    }
    
    @IBAction func clearAction(_ sender: Any) {
        titleTextField.text = ""
        descriptionTextView.text = ""
        didEditTitle = false
        didEditDescription = false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showConfirmAddDealVC") {
            let destVC = segue.destination as? ConfirmAddDealViewController
            
            destVC?.dealTitle = dealTitle
            destVC?.dealDescription = dealDescription
            destVC?.restaurantName = restaurant?.name
        }
    }
}
