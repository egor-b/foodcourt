//
//  NewStepTableViewCellViewModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/28/21.
//

import Foundation

class NewStepTableViewCellViewModel: NewStepTableViewCellViewModelProtocol {
    
    var step: StepModel
    
    init(step: StepModel) {
        self.step = step
    }
}
