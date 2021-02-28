//
//  IngredientOfRecipeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import UIKit

class IngredientOfRecipeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkMarkBoxButton: UIButton!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var countOfIngredientLabel: UILabel!
    
    weak var viewModel: IngredientTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            ingredientNameLabel?.text = viewModel.ingredient.name
            countOfIngredientLabel?.text = String(describing: viewModel.ingredient.count) + " " + String(describing: viewModel.ingredient.messuer)
        }
    }
    
}
