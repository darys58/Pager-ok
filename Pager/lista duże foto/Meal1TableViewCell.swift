//
//  Meal1TableViewCell.swift
//  Pager
//
//  Created by darys on 07.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal1TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView1: UIImageView!    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var cenaLabel1: UILabel!
    @IBOutlet weak var czasLabel1: UILabel!
    @IBOutlet weak var wagaLabel1: UILabel!
    @IBOutlet weak var kcalLabel1: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var uwaga1: UIImageView!
    @IBOutlet weak var ulubione1: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
