//
//  MainMenuCollectionViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/4/20.
//

import UIKit

class MainMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cathegoryImageView: UIImageView!
    @IBOutlet weak var cathegoryMenuLabel: UILabel!
    
    override func layoutSubviews() {
        cathegoryImageView.layer.cornerRadius = 5
    }
}
