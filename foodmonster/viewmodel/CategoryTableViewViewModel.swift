//
//  TableViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation


protocol CategoryTableViewViewModelProtocol {
    
    var listOfResipes: WrapedRecipe { get }
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol?
    
    func selectedRow(atIndexPath indexPath: IndexPath)
    
    func getListByType(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(RecipeError?) -> ())
    func getListByUserId(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(RecipeError?) -> ())
    
    func getRecipeList() -> [Recipe]
    
    func setRecipeList(_ list: [Recipe])
    func getRecipeByIndex(index: Int) -> Recipe
    func updateRecipeByIndex(index: Int, recipe: Recipe?)
    func addNewRecipe(recipe: Recipe)
}

/// View model for Category Table View Controller
class CategoryTableViewViewModel: CategoryTableViewViewModelProtocol {
    
    private var dataNetworkManager: DataNetworkManagerProtocol?
    
    private var selectedIndexPath: IndexPath?
    
    var listOfResipes = WrapedRecipe()
    
    init() {
        dataNetworkManager = DataNetworkManager()
    }
        
    func numberOfRows() -> Int {
        return listOfResipes.recipeList.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol? {
        let recipe = listOfResipes.recipeList[indexPath.row]
        return RecipeTableViewCellViewModel(recipe: recipe)
    }
    
    //Review
    func selectedRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getListByType(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(RecipeError?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.getRecipes(page: page, size: size, sort: sort, order: order, filter: filter, completion: { [weak self] (recipe, err) in
            if let err = err {
                completion(err)
            }
            if let recipe = recipe {
                if page == "0" {
                    self?.listOfResipes = recipe
                } else {
                    self?.listOfResipes.recipeList += recipe.recipeList
                }
            }
            completion(nil)
        })
    }
    
    func getListByUserId(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(RecipeError?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.getRecipesByUser(userId: globalUserId, page: page, size: size, sort: sort, order: order, filter: filter) { [weak self] recipe, err in
            if let err = err {
                completion(err)
            }
            if let recipe = recipe {
                if page == "0" {
                    self?.listOfResipes = recipe
                } else {
                    self?.listOfResipes.recipeList += recipe.recipeList
                }
            }
            completion(nil)
        }
    }
    
    func getRecipeList() -> [Recipe] {
        return listOfResipes.recipeList
    }
    
    func setRecipeList(_ list: [Recipe]) {
        listOfResipes.recipeList = list
    }
    
    func getRecipeByIndex(index: Int) -> Recipe {
        return listOfResipes.recipeList[index]
    }
    
    func updateRecipeByIndex(index: Int, recipe: Recipe?) {
        guard let recipe = recipe else { return }
        listOfResipes.recipeList[index] = recipe
    }
    
    func addNewRecipe(recipe: Recipe) {
        listOfResipes.recipeList.insert(recipe, at: 0)
    }
}
