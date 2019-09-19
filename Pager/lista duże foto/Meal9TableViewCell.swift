//
//  Meal9TableViewCell.swift
//  Pager
//
//  Created by darys on 05.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal9TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView9: UIImageView!
    @IBOutlet weak var nameLabel9: UILabel!
    @IBOutlet weak var cenaLabel9: UILabel!
    @IBOutlet weak var czasLabel9: UILabel!
    @IBOutlet weak var wagaLabel9: UILabel!
    @IBOutlet weak var kcalLabel9: UILabel!
    @IBOutlet weak var starsView9: CosmosView!
    @IBOutlet weak var uwaga9: UIImageView!
    @IBOutlet weak var ulubione9: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
