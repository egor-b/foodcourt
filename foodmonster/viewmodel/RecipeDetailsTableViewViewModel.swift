//
//  RecipeDetailsTableViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

class RecipeDetailsTableViewViewModel: RecipeDetailsTableViewViewModelProtocol {
    
    private var recipe: Recipe!
    
    func numberOfSection() -> Int {
        return 4
    }
    
    func numberOfRowsInSection(numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return recipe.food.count + 1
        }
        if section == 3 {
            return recipe.step.count
        }
        return 1
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol? {
        return RecipeTableViewCellViewModel(recipe: recipe)
    }
    
    func ingredientCellViewModel(forIndexPath indexPath: IndexPath) -> IngredientTableViewCellViewModelProtocol? {
        return IngredientTableViewCellViewModel(ingredient: recipe.food[indexPath.row - 1])
    }
    
    func stepCellViewModel(forIndexPath indexPath: IndexPath) -> StepOfRecipeTableViewCellViewModelProtocol? {
        return StepOfRecipeTableViewCellViewModel(step: recipe.step[indexPath.row])
    }
    
    func getRecipeValue(value: Recipe) {
        self.recipe = value
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
