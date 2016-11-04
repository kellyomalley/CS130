//
//  Cells.swift
//  BoredBets
//
//  Created by Kyle Baker on 11/2/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

