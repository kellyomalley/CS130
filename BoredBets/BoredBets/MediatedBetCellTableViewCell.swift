//
//  MediatedBetCellTableViewCell.swift
//  BoredBets
//
//  Created by Markus Notti on 11/21/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MediatedBetCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var coinStackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
