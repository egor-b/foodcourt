//
//  RecipeCategoryTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/22/20.
//

import UIKit

class RecipeCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cathegoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
