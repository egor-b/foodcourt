//
//  Image.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 11/22/21.
//

import Foundation

struct Image: Codable {
    
    var id: Int64 = 0
    var pic: String = ""
    var img = Data()
    
    internal init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case pic = "pic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        if let pic = try values.decodeIfPresent(String.self, forKey: .pic) {
            self.pic = pic
        }
    }
}
