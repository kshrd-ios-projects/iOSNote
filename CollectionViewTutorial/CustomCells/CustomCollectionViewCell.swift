//
//  CustomCollectionViewCell.swift
//  CollectionViewTutorial
//
//  Created by Sreng Khorn on 9/12/18.
//  Copyright © 2018 Sreng Khorn. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
