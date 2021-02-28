//
//  TableViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

class TableViewViewModel: TableViewViewModelProtocol {
    
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
    
    func viewModelForSelectedRow() -> RecipeTableViewCellViewModel? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return RecipeTableViewCellViewModel(recipe: listOfResipes[selectedIndexPath.row])
    }
    
    func selectedRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getListByType(type: String, completion: @escaping() -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.getRecipes(completion: { [weak self] recipe in
            self?.listOfResipes = recipe
            completion()
        })
    }
    
    func getListByUserId(userId id: String, completion: @escaping() -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.getRecipesByUser(userId: Int64(id)!, completion: { [weak self] recipe in
            self?.listOfResipes = recipe
            completion()
        })
    }
    
}
