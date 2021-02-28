//
//  StepOfRecipeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import UIKit

class StepOfRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var numberOfStepLabel: UILabel!
    @IBOutlet weak var stepDescriptionLabel: UILabel!
    
    weak var viewModel: StepOfRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            numberOfStepLabel?.text = "Step " + String(describing: viewModel.step.stepNumber)
            stepDescriptionLabel?.text = viewModel.step.steDescription
        }
    }

}
