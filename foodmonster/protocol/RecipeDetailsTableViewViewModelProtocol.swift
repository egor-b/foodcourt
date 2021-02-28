//
//  RecipeDetailsTableViewViewModelType.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

protocol RecipeDetailsTableViewViewModelProtocol: class {
    
    func numberOfSection() -> Int
    func numberOfRowsInSection(numberOfRowsInSection section: Int) -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol?
    func ingredientCellViewModel(forIndexPath indexPath: IndexPath) -> IngredientTableViewCellViewModelProtocol?
    func stepCellViewModel(forIndexPath indexPath: IndexPath) -> StepOfRecipeTableViewCellViewModelProtocol?
    
    
    
    func getRecipeValue(value: Recipe)
    
}
