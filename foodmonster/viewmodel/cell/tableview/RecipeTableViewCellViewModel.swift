//
//  CathegoryTableViewCellViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

class RecipeTableViewCellViewModel: RecipeTableViewCellViewModelProtocol {

    var recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    
}
