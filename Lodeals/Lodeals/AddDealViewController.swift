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
    
    var didEditTitle = false
    var didEditDescription = false
    var restaurant : Restaurant?
    var dealTitle : String = ""
    var dealDescription : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ("New deal for \(restaurant?.name ?? "null"):")
        titleTextField.addTarget(self, action: #selector(didChangeTitle(_:)), for: .editingChanged)
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
        dealTitle = textField.text!
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
        }
    }
}
