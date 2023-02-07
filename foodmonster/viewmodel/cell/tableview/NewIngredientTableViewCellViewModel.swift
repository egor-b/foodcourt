//
//  NewIngredientTableViewCellViewModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/28/21.
//

import Foundation

class NewIngredientTableViewCellViewModel: NewIngredientTableViewCellViewModelProtocol {
    
    var ingredient: FoodModel
    
    init(ingredient: FoodModel) {
        self.ingredient = ingredient
    }
}
