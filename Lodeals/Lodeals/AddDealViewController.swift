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
    var newDeal = Deal(totalTimesUsed: 1, lastUsed: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ("New deal for \(restaurant?.name ?? "null"):")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(!didEditTitle) {
            textField.text = ""
            didEditTitle = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newDeal.shortDescription = textField.text!
        
        print("title: \(newDeal.shortDescription)")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(!didEditDescription) {
            textView.text = ""
            didEditDescription = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        newDeal.description = textView.text
        
        print("description: \(newDeal.description)")
    }
    
    @IBAction func clearAction(_ sender: Any) {
        titleTextField.text = ""
        descriptionTextView.text = ""
        didEditTitle = false
        didEditDescription = false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
