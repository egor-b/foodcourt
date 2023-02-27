//
//  ImageModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/4/22.
//

import Foundation

struct ImageModel: Codable {
    
    var id: Int64 = 0
    var pic: String = ""
    var img = Data()
    
}
