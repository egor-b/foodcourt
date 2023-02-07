//
//  PortionsTableViewCell.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/2/22.
//

import UIKit

class PortionsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var potryionsLabel: UILabel!
    @IBOutlet private weak var portionsStepper: UIStepper!
    
    var stepperValue: Int = 0
    
    weak var viewModel: NewRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            stepperValue = viewModel.recipe.serve
            potryionsLabel.text = String(viewModel.recipe.serve)
            portionsStepper.value = Double(stepperValue)
            portionsStepper.minimumValue = 1
            portionsStepper.addTarget(self, action: #selector(changePortionAmount), for: .valueChanged)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func changePortionAmount() {
        stepperValue = Int(portionsStepper.value)
        potryionsLabel.text = String(stepperValue)
    }

}
