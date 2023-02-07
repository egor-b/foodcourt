//
//  PurchaseModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/10/22.
//

import Foundation

struct PurchaseModel: Codable {
    
    var id: Int64 = 0
    var recipeName: String = ""
    var serve: Int = 0
    var size: Double = 0
    var recipeId: Int64 = 0
    var isAvailable: Bool = false
    var foodId: Int64 = 0
    var userId = globalUserId
    
}
