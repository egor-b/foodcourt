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
    private let ingredients = Bundle.main.localizedString(forKey: "ingredients", value: LocalizationDefaultValues.INGREDIENT.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let serves = Bundle.main.localizedString(forKey: "serves", value: LocalizationDefaultValues.SERVES.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            stepperValue = viewModel.recipe.serve
            changeServeStepper.value = Double(stepperValue)
            changeServeStepper.minimumValue = 1
            changeServeStepper.maximumValue = 20
            changeServeStepper.addTarget(self, action: #selector(changePortionAmount), for: .valueChanged)
            serveLabel?.text = "\(ingredients) / \(stepperValue) \(serves)"
        }
    }

    @objc func changePortionAmount() {
        stepperValue = Int(changeServeStepper.value)
        serveLabel?.text = "\(ingredients) / \(stepperValue) \(serves)"
    }
    
    func disableStepper(isEnable: Bool) {
        changeServeStepper.isEnabled = isEnable
    }
    
}
