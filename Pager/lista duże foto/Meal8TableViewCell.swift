//
//  Meal8TableViewCell.swift
//  Pager
//
//  Created by darys on 05.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal8TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView8: UIImageView!
    @IBOutlet weak var nameLabel8: UILabel!
    @IBOutlet weak var cenaLabel8: UILabel!
    @IBOutlet weak var czasLabel8: UILabel!
    @IBOutlet weak var wagaLabel8: UILabel!
    @IBOutlet weak var kcalLabel8: UILabel!
    @IBOutlet weak var starsView8: CosmosView!
    @IBOutlet weak var uwaga8: UIImageView!
    @IBOutlet weak var ulubione8: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
