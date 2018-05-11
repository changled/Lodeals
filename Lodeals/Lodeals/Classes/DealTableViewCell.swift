//
//  DealTableViewCell.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/8/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
