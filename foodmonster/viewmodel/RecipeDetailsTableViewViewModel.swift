//
//  RecipeDetailsTableViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation
import UIKit

protocol RecipeDetailsTableViewViewModelProtocol: AnyObject {
    
    func numberOfSection() -> Int
    func numberOfRowsInSection(numberOfRowsInSection section: Int) -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol?
    func ingredientCellViewModel(forIndexPath indexPath: IndexPath) -> IngredientTableViewCellViewModelProtocol?
    func stepCellViewModel(forIndexPath indexPath: IndexPath) -> StepOfRecipeTableViewCellViewModelProtocol?
    
    func getRecipeValue() -> Recipe?
    func getRecipe(_ id: Int64, completion: @escaping (Error?) -> ())
    func calcNewingredientWeight(portions: Int, tableView: UITableView)
}

class RecipeDetailsTableViewViewModel: RecipeDetailsTableViewViewModelProtocol {
    
    private var recipe: Recipe?
    
    private var networkManger: DataNetworkManagerProtocol?
    
    init(recipe: Recipe) {
        self.recipe = recipe
        networkManger = DataNetworkManager()
    }
    
    init() {
        networkManger = DataNetworkManager()
    }
    
    func numberOfSection() -> Int {
        return 4
    }
    
    func numberOfRowsInSection(numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            guard let recipe = recipe else { return 0 }
            return recipe.food.count + 1
        }
        if section == 3 {
            guard let recipe = recipe else { return 0 }
            return recipe.step.count
        }
        return 1
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol? {
        guard let recipe = recipe else { return nil }
        return RecipeTableViewCellViewModel(recipe: recipe)
    }
    
    func ingredientCellViewModel(forIndexPath indexPath: IndexPath) -> IngredientTableViewCellViewModelProtocol? {
        guard let recipe = recipe else { return nil }
        return IngredientTableViewCellViewModel(ingredient: recipe.food[indexPath.row - 1], recipe: recipe)
    }
    
    func stepCellViewModel(forIndexPath indexPath: IndexPath) -> StepOfRecipeTableViewCellViewModelProtocol? {
        guard var recipe = recipe else { return nil }
        recipe.step = recipe.step.sorted(by: { $0.stepNumber < $1.stepNumber})
        return StepOfRecipeTableViewCellViewModel(step: recipe.step[indexPath.row])
    }
    
    func getRecipeValue() -> Recipe? {
        return recipe
    }
    
    func getRecipe(_ id: Int64, completion: @escaping (Error?) -> ()) {
        guard let networkManger = networkManger else { return }
        networkManger.getRecipeByRecipeId(id: id) { [weak self] (recipe, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(err)
            }
            self?.recipe = recipe
            completion(nil)
        }
    }
    
    func calcNewingredientWeight(portions: Int, tableView: UITableView) {
        guard var recipe = recipe else { return }
        
        for (i,f) in recipe.food.enumerated() {
            var newWeight = Double()
            let portionWeight = f.size / Double(recipe.serve)
            if recipe.serve < portions {
                newWeight = recipe.food[i].size + portionWeight
            } else {
                newWeight = recipe.food[i].size - portionWeight
            }
            recipe.food[i].size = newWeight
            if var cell = tableView.cellForRow(at: IndexPath(row: i+1, section: 1)) as? IngredientOfRecipeTableViewCell {
                cell.countOfIngredientLabel.text = "\(newWeight) \(recipe.food[i].measure)"
                cell.purchase.size = newWeight
                cell.purchase.serve = portions
            }
        }
        if var cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ServeTableViewCell {
            cell.serveLabel.text = "Ingredients / \(portions) serves"

        }
        recipe.serve = portions
    }
    
}
