//
//  RecipeNameTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/22/20.
//

import UIKit

class RecipeNameTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!

    weak var viewModel: NewRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            recipeNameLabel.text = viewModel.recipe.name
        }
    }
}
