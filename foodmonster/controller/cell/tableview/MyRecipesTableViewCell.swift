//
//  MyRecipesTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/17/20.
//

import UIKit

class MyRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var recipeCellView: UIView!
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            recipeNameLabel.text = viewModel.recipe.name
            
        }
    }
    
    override func layoutSubviews() {
        recipeCellView.layer.cornerRadius = 5
    }
}
