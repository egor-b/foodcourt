//
//  Step.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/11/20.
//

import Foundation

struct Step: Codable {
    
    var id: Int64 = 0
    var stepNumber: Int = 0
    var step: String = ""
    var pic: String = ""
    var img = Data()
    
    internal init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case stepNumber = "stepNumber"
        case step = "step"
        case pic = "pic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        if let stepNumber = try values.decodeIfPresent(Int.self, forKey: .stepNumber) {
            self.stepNumber = stepNumber
        }
        if let step = try values.decodeIfPresent(String.self, forKey: .step) {
            self.step = step
        }
        if let pic = try values.decodeIfPresent(String.self, forKey: .pic) {
            self.pic = pic
        }
    }
    
}
