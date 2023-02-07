//
//  Food.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/11/20.
//

import Foundation

struct Food: Codable {
    
    var id: Int64 = 0
    var foodstuff = Foodstuff()
    var size: Double = 0.0
    var measure: String = ""
    
    internal init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case foodstuff = "foodstuff"
        case size = "size"
        case measure = "measure"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        
        if let foodstuff = try values.decodeIfPresent(Foodstuff.self, forKey: .foodstuff) {
            self.foodstuff = foodstuff
        }
        if let size = try values.decodeIfPresent(Double.self, forKey: .size) {
            self.size = size
        }
        if let measure = try values.decodeIfPresent(String.self, forKey: .measure){
            self.measure = measure
        }
    }
}
