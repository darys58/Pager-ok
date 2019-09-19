//
//  Meal4TableViewCell.swift
//  Pager
//
//  Created by darys on 22.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal4TableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView4: UIImageView!
    @IBOutlet weak var nameLabel4: UILabel!
    @IBOutlet weak var cenaLabel4: UILabel!
    @IBOutlet weak var czasLabel4: UILabel!
    @IBOutlet weak var wagaLabel4: UILabel!
    @IBOutlet weak var kcalLabel4: UILabel!
    @IBOutlet weak var starsView4: CosmosView!
    @IBOutlet weak var uwaga4: UIImageView!
    @IBOutlet weak var ulubione4: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
