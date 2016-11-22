//
//  ActiveBetTableViewCell.swift
//  BoredBets
//
//  Created by Markus Notti on 11/21/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class ActiveBetTableViewCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var potLabel: UILabel!
    //TODO: make linkable to user
    @IBOutlet weak var mediatorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
