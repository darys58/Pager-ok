//
//  Meal7TableViewCell.swift
//  Pager
//
//  Created by darys on 05.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal7TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView7: UIImageView!
    @IBOutlet weak var nameLabel7: UILabel!
    @IBOutlet weak var cenaLabel7: UILabel!
    @IBOutlet weak var czasLabel7: UILabel!
    @IBOutlet weak var wagaLabel7: UILabel!
    @IBOutlet weak var kcalLabel7: UILabel!
    @IBOutlet weak var starsView7: CosmosView!
    @IBOutlet weak var uwaga7: UIImageView!
    @IBOutlet weak var ulubione7: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
