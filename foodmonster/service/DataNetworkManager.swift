//
//  DataNetworkManager.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/9/20.
//

import Foundation

class DataNetworkManager: DataNetworkManagerProtocol {
    
    private var result = [Recipe(name: "Name 1", time: 40, serve: 2, level: 3, type: "meat", about: "mwoeigw", visible: true, food: [Food(name: "123", count: 2.3, messuer: "eee"),
                                                                                                                                    Food(name: "123dfg", count: 23, messuer: "eweree"),
                                                                                                                                    Food(name: "123ertr", count: 2, messuer: "43eee"),
                                                                                                                                    Food(name: "12erh3", count: 2.334, messuer: "eeg45be")], step: [Step(stepNumber: 1, steDescription: "q")]),
                         Recipe(name: "Name 2", time: 403, serve: 4, level: 3.4, type: "seafood", about: "mwoeigw", visible: true, food: [Food(name: "123", count: 2.3, messuer: "eee"),
                                                                                                                                          Food(name: "123dfg", count: 23, messuer: "eweree")], step: [Step(stepNumber: 1, steDescription: "q")]),
                         Recipe(name: "Name 3", time: 5, serve: 1, level: 3.5, type: "meat", about: "mwoeigw", visible: true, food: [Food(name: "123", count: 2.3, messuer: "eee"),
                                                                                                                                     Food(name: "123dfg", count: 23, messuer: "eweree"),
                                                                                                                                     Food(name: "123ertr", count: 2, messuer: "43eee")], step: [Step(stepNumber: 1, steDescription: "q")]),
                         Recipe(name: "Name 4", time: 43, serve: 3, level: 1, type: "meat", about: "mwoeigw", visible: true, food: [Food(name: "123", count: 2.3, messuer: "eee"),
                                                                                                                                    Food(name: "123dfg", count: 23, messuer: "eweree"),
                                                                                                                                    Food(name: "123ertr", count: 2, messuer: "43eee"),
                                                                                                                                    Food(name: "12erh3", count: 2.334, messuer: "eeg45be"),
                                                                                                                                    Food(name: "123", count: 2.3, messuer: "eee"),
                                                                                                                                    Food(name: "123dfg", count: 23, messuer: "eweree"),
                                                                                                                                    Food(name: "123ertr", count: 2, messuer: "43eee"),
                                                                                                                                    Food(name: "12erh3", count: 2.334, messuer: "eeg45be")], step: [Step(stepNumber: 1, steDescription: "q")])]
    
    func getRecipes(completion: ([Recipe]) -> ()) {
        completion(result)
    }
    
    func getRecipeByRecipeId(id: Int64, completion: (Recipe) -> ()) {
        var recipe: Recipe!
        recipe.name = "1"
        completion(recipe)
    }
    
    func getRecipesByUser(userId: Int64, completion: ([Recipe]) -> ()) {
        var recipes = [Recipe]()
        recipes = result + result
        completion(recipes)
    }
    
    func searchRecipesByFilter() {
    }
    
    func saveRecipe(recipe: Recipe, completion: ([Any]) -> ()) {
        var s = [String]()
        completion([s])
    }
    
}
