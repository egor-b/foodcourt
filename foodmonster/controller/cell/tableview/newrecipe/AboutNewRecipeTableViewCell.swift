//
//  AboutNewRecipeTableViewCell.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/28/21.
//

import Foundation
import UIKit

class AboutNewRecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var aboutNewRecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        aboutNewRecipeLabel.sizeToFit()
        // Initialization code
    }
    
    weak var viewModel: NewRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return }
            aboutNewRecipeLabel?.text = viewModel.recipe.about
        }
    }
    
}
