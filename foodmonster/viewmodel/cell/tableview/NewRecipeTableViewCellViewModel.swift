//
//  NewRecipeTableViewCellViewModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/28/21.
//

import Foundation

class NewRecipeTableViewCellViewModel: NewRecipeTableViewCellViewModelProtocol {
    
    var recipe: RecipeModel
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
}
