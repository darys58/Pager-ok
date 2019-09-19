//
//  Meal3TableViewCell.swift
//  Pager
//
//  Created by darys on 22.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal3TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView3: UIImageView!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var cenaLabel3: UILabel!
    @IBOutlet weak var czasLabel3: UILabel!
    @IBOutlet weak var wagaLabel3: UILabel!
    @IBOutlet weak var kcalLabel3: UILabel!
    @IBOutlet weak var starsView3: CosmosView!
    @IBOutlet weak var uwaga3: UIImageView!
    @IBOutlet weak var ulubione3: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
