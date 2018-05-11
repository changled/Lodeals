//
//  DealSectionHeaderView.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/10/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

// created with instruction from a Medium article by @brianclouser called "Swift 3 — Creating a custom view from a xib"
class DealSectionHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var lastUsedLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    
    //for using CustomView in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    //for using CustomView in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DealSectionHeaderView", owner: self, options: nil) //load xib by name from memory
        addSubview(contentView)
        
        //position content view to take up entire view's appearance
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
