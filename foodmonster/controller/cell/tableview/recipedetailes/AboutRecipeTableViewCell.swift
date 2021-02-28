//
//  AboutRecipeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import UIKit

class AboutRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel!
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return }
            aboutLabel?.text = viewModel.recipe.about
        }
    }

}
