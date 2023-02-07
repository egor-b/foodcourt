//
//  NewIngredientTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/22/20.
//

import UIKit

class NewIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    weak var viewModel: NewIngredientTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            nameLabel.text = viewModel.ingredient.foodstuff.name
            amountLabel.text = "/ " + String(viewModel.ingredient.size) + " " + viewModel.ingredient.measure
        }
    }

}
