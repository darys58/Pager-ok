//
//  OpinieTableViewCell.swift
//  Pager
//
//  Created by darys on 01.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import Cosmos

class OpinieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var sredniaLabel: UILabel!
    @IBOutlet weak var dodanoLabel: UILabel!
    @IBOutlet weak var tytulLabel: UILabel!
    @IBOutlet weak var opiniaTextView: UITextView!
    @IBOutlet weak var starsView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
