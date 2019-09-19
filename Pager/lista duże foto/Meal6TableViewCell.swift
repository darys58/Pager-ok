//
//  Meal6TableViewCell.swift
//  Pager
//
//  Created by darys on 05.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal6TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView6: UIImageView!
    @IBOutlet weak var nameLabel6: UILabel!
    @IBOutlet weak var cenaLabel6: UILabel!
    @IBOutlet weak var czasLabel6: UILabel!
    @IBOutlet weak var wagaLabel6: UILabel!
    @IBOutlet weak var kcalLabel6: UILabel!
    @IBOutlet weak var starsView6: CosmosView!
    @IBOutlet weak var uwaga6: UIImageView!
    @IBOutlet weak var ulubione6: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
