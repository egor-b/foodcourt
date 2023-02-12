//
//  WrapedRecipe.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/11/23.
//

import Foundation

struct WrapedRecipe: Codable {
    
    var recipeList: [Recipe] = [Recipe]()
    var totalPages = 0
    
    internal init () {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case recipeList = "recipeList"
        case totalPages = "totalPages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let recipeList = try values.decodeIfPresent([Recipe].self, forKey: .recipeList) {
            self.recipeList = recipeList
        }
        if let totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages) {
            self.totalPages = totalPages
        }
        
    }
    
}
