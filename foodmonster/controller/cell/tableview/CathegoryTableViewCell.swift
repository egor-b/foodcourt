//
//  CathegoryTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import UIKit

class CathegoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var cathegoryCellView: UIView!
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel){
            guard let viewModel = viewModel else { return }
            dishNameLabel.text = viewModel.recipe.name
            cookingTimeLabel.text = String(describing: viewModel.recipe.time)
        }
    }

    override func layoutSubviews() {
        cathegoryCellView.layer.cornerRadius = 5
    }
     
}
