//
//  Food.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/11/20.
//

import Foundation

struct Food: Codable {
    
    var id: Int64 = 0
    var product = Product()
    var amount: Double = 0.0
    var unit: String = ""
    
    internal init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case product = "product"
        case amount = "amount"
        case unit = "unit"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        
        if let product = try values.decodeIfPresent(Product.self, forKey: .product) {
            self.product = product
        }
        if let amount = try values.decodeIfPresent(Double.self, forKey: .amount) {
            self.amount = amount
        }
        if let unit = try values.decodeIfPresent(String.self, forKey: .unit){
            self.unit = unit
        }
    }
}
