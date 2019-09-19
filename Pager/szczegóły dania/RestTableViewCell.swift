//
//  RestTableViewCell.swift
//  Pager
//
//  Created by darys on 24.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit

class RestTableViewCell: UITableViewCell {

    @IBOutlet weak var nazwaLabel: UILabel!
    @IBOutlet weak var cenaLabel: UILabel!
    @IBOutlet weak var adresLabel: UILabel!  
    @IBOutlet weak var otwarteText: UITextView!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var wwwButton: UIButton!
    @IBOutlet weak var gpsButton: UIButton!
    @IBOutlet weak var facilButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
