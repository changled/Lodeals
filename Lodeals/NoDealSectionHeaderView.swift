//
//  NoDealSectionHeaderView.swift
//  Lodeals
//
//  Created by Rachel Chang on 6/5/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class NoDealSectionHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var SubmitDealButton: UIButton!
    
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
        //load xib by name from memory
        Bundle.main.loadNibNamed("NoDealSectionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        
        //position content view to take up entire view's appearance
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
