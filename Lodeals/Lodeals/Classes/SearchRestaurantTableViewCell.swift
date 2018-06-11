//
//  SearchRestaurantTableViewCell.swift
//  Lodeals
//
//  Created by Rachel Chang on 6/11/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

class SearchRestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var deal1Label: UILabel!
    @IBOutlet weak var deal2Label: UILabel!
    @IBOutlet weak var deal1TimeLabel: UILabel!
    @IBOutlet weak var deal2TimeLabel: UILabel!
    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var imgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        restImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
