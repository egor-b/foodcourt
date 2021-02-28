//
//  InfoRecipeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import UIKit

class InfoRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var cookTimeLabel: UILabel!
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            cookTimeLabel?.text = String(describing: viewModel.recipe.time)
        }
    }
    
}
