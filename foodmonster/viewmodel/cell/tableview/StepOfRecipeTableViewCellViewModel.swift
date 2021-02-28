//
//  StepOfRecipeTableViewCellViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/11/20.
//

import Foundation

class StepOfRecipeTableViewCellViewModel: StepOfRecipeTableViewCellViewModelProtocol {
    var step: Step
    
    init(step: Step) {
        self.step = step
    }
}
