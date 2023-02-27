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
    var amount: Double = 0.0
    var recipeId: Int64 = 0
    var isAvailable: Bool = false
    var foodId: Int64 = 0
    var userId = globalUserId
    
    internal init() { }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case recipeName = "recipeName"
        case serve = "serve"
        case amount = "amount"
        case recipeId = "recipeId"
        case isAvailable = "isAvailable"
        case foodId = "foodId"
        case userId = "userId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        
        if let recipeName = try values.decodeIfPresent(String.self, forKey: .recipeName) {
            self.recipeName = recipeName
        }
        if let serve = try values.decodeIfPresent(Int.self, forKey: .serve) {
            self.serve = serve
        }
        if let amount = try values.decodeIfPresent(Double.self, forKey: .amount){
            self.amount = amount
        }
        if let recipeId = try values.decodeIfPresent(Int64.self, forKey: .recipeId) {
            self.recipeId = recipeId
        }
        
        if let isAvailable = try values.decodeIfPresent(Bool.self, forKey: .isAvailable) {
            self.isAvailable = isAvailable
        }
        if let foodId = try values.decodeIfPresent(Int64.self, forKey: .foodId) {
            self.foodId = foodId
        }
        if let userId = try values.decodeIfPresent(String.self, forKey: .userId){
            self.userId = userId
        }
    }
}
