//
//  IngredientTableViewCellViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import Foundation
import UIKit

class IngredientTableViewCellViewModel: IngredientTableViewCellViewModelProtocol {
    
    var ingredient: Food
    var recipe: Recipe
    
    init(ingredient: Food, recipe: Recipe) {
        self.ingredient = ingredient
        self.recipe = recipe
    }
}
