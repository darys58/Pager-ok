//
//  Meal5TableViewCell.swift
//  Pager
//
//  Created by darys on 22.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal5TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView5: UIImageView!
    @IBOutlet weak var nameLabel5: UILabel!
    @IBOutlet weak var cenaLabel5: UILabel!
    @IBOutlet weak var czasLabel5: UILabel!
    @IBOutlet weak var wagaLabel5: UILabel!
    @IBOutlet weak var kcalLabel5: UILabel!
    @IBOutlet weak var starsView5: CosmosView!
    @IBOutlet weak var uwaga5: UIImageView!
    @IBOutlet weak var ulubione5: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
