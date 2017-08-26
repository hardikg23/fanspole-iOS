//
//  HomeMunuCell.swift
//  fanspole
//
//  Created by Hardik on 26/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit


class HomeMenuCell: UICollectionViewCell{
    
    @IBOutlet weak var homeMenuCellLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            homeMenuCellLabel.textColor = isHighlighted ? UIColor.white : UIColor.lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            homeMenuCellLabel.textColor = isSelected ? UIColor.white : UIColor.lightGray
        }
    }
    
}
