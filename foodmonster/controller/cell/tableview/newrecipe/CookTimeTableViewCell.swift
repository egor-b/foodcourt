//
//  CookTimeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/22/20.
//

import UIKit

class CookTimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cookTimeLabel: UILabel!

    weak var viewModel: NewRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            cookTimeLabel.text = String(viewModel.recipe.time) + " min"
        }
    }

}
