//
//  RecipeDetailTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import UIKit

class RecipeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!

    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            name.text = viewModel.recipe.name
        }
    }
}
