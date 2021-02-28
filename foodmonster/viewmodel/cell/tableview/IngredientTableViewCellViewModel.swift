//
//  IngredientTableViewCellViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import Foundation

class IngredientTableViewCellViewModel: IngredientTableViewCellViewModelProtocol {
    var ingredient: Food
    
    init(ingredient: Food) {
        self.ingredient = ingredient
    }
}
