//
//  Meal2TableViewCell.swift
//  Pager
//
//  Created by darys on 13.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal2TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView2: UIImageView!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var cenaLabel2: UILabel!
    @IBOutlet weak var czasLabel2: UILabel!
    @IBOutlet weak var wagaLabel2: UILabel!
    @IBOutlet weak var kcalLabel2: UILabel!
    @IBOutlet weak var starsView2: CosmosView!
    @IBOutlet weak var uwaga2: UIImageView!
    @IBOutlet weak var ulubione2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
