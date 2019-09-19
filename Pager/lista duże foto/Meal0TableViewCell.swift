//
//  Meal0TableViewCell.swift
//  Pager
//
//  Created by darys on 07.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Cosmos

class Meal0TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView0: UIImageView!
    @IBOutlet weak var nameLabel0: UILabel!
    @IBOutlet weak var cenaLabel0: UILabel!
    @IBOutlet weak var czasLabel0: UILabel!
    @IBOutlet weak var wagaLabel0: UILabel!
    @IBOutlet weak var kcalLabel0: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var uwaga0: UIImageView!
    @IBOutlet weak var ulubione0: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
