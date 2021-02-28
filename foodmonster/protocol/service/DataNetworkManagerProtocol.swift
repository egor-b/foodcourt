//
//  DataNetworkManagerProtocol.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/9/20.
//

import Foundation

protocol DataNetworkManagerProtocol {
    
    func getRecipes(completion: ([Recipe]) -> ())
    func getRecipeByRecipeId(id: Int64, completion: (Recipe) -> ())
    func getRecipesByUser(userId: Int64, completion: ([Recipe]) -> ())
    func searchRecipesByFilter()
    
    func saveRecipe(recipe: Recipe, completion: ([Any]) -> ())
    
}
