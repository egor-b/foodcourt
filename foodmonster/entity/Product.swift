//
//  Product.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/4/22.
//

import Foundation

struct Product: Codable {
    
    var id: Int64 = 0
    var name: String = ""
    var pic: String = ""
    var img = Data()
    
    internal init () {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case pic = "pic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        if let name = try values.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        }
        if let pic = try values.decodeIfPresent(String.self, forKey: .pic){
            self.pic = pic
        }
        
    }
}
