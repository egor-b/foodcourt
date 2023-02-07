//
//  Purchase.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import Foundation

struct Purchase: Codable {
    
    var recipeName: String = ""
    var serve: Int = 0
    var recipeId: Int64 = 0
    var food: [PurchaseFood] = []
    
}
