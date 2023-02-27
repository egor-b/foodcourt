//
//  FoodModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/20/21.
//

import Foundation

struct FoodModel: Codable {
    
    var id: Int64 = 0
    var product = FoodStorage()
    var amount: Double = 0.0
    var unit: String = ""
    
}
