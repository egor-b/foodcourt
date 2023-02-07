//
//  TableViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation


protocol CategoryTableViewViewModelProtocol {
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol?
    
    func selectedRow(atIndexPath indexPath: IndexPath)
    
    func getListByType(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(Bool, RecipeError?) -> ())
    func getListByUserId(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(Bool, RecipeError?) -> ())
    
    func getRecipeList() -> [Recipe]
    
    func setRecipeList(_ list: [Recipe])
    func getRecipeByIndex(index: Int) -> Recipe
    
}

/// View model for Category Table View Controller
class CategoryTableViewViewModel: CategoryTableViewViewModelProtocol {
    
    private var dataNetworkManager: DataNetworkManagerProtocol?
    
    private var selectedIndexPath: IndexPath?
    
    private var listOfResipes = [Recipe]()
    
    init() {
        dataNetworkManager = DataNetworkManager()
    }
        
    func numberOfRows() -> Int {
        return listOfResipes.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol? {
        let recipe = listOfResipes[indexPath.row]
        return RecipeTableViewCellViewModel(recipe: recipe)
    }
    
    //Review
    func selectedRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getListByType(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(Bool, RecipeError?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.getRecipes(page: page, size: size, sort: sort, order: order, filter: filter, completion: { [weak self] (recipe, err) in
            if let err = err {
                completion(false, err)
            }
            if let recipe = recipe {
                if recipe.count != 0 {
                    if page == "0" {
                        self?.listOfResipes = recipe
                    } else {
                        self?.listOfResipes += recipe
                    }
                    completion(false, nil)
                } else {
                    completion(true, nil)
                }
            }
        })
    }
    
    func getListByUserId(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping(Bool, RecipeError?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.getRecipesByUser(userId: globalUserId, page: page, size: size, sort: sort, order: order, filter: filter) { [weak self] recipe, err in
            if let err = err {
                completion(false, err)
            }
            if let recipe = recipe {
                if recipe.count != 0 {
                    if page == "0" {
                        self?.listOfResipes = recipe
                    } else {
                        self?.listOfResipes += recipe
                    }
                    completion(false, nil)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
    func getRecipeList() -> [Recipe] {
        return listOfResipes
    }
    
    func setRecipeList(_ list: [Recipe]) {
        listOfResipes = list
    }
    
    func getRecipeByIndex(index: Int) -> Recipe {
        return listOfResipes[index]
    }
}
