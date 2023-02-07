//
//  ServeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit

class ServeTableViewCell: UITableViewCell {

    @IBOutlet weak var serveLabel: UILabel!
    @IBOutlet weak var changeServeStepper: UIStepper!
    
    private var stepperValue: Int = 0
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            stepperValue = viewModel.recipe.serve
            changeServeStepper.value = Double(stepperValue)
            changeServeStepper.minimumValue = 1
            changeServeStepper.maximumValue = 20
            changeServeStepper.addTarget(self, action: #selector(changePortionAmount), for: .valueChanged)
            serveLabel?.text = "Ingredients / \(stepperValue) serves"
        }
    }

    @objc func changePortionAmount() {
        stepperValue = Int(changeServeStepper.value)
        serveLabel?.text = "Ingredients / \(stepperValue) serves"
    }
    
    func disableStepper(isEnable: Bool) {
        changeServeStepper.isEnabled = isEnable
    }
    
}
