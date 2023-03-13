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
            let time = String(describing: viewModel.recipe.time)
            cookTimeLabel?.text = "\(time) \(Bundle.main.localizedString(forKey: "min", value: LocalizationDefaultValues.MIN.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue))"
        }
    }
    
}
