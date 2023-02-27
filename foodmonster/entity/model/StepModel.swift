//
//  StepModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/20/21.
//

import Foundation

struct StepModel: Codable {
    
    var id: Int64 = 0
    var stepNumber: Int = 0
    var step: String = ""
    var pic: String = ""
    var img = Data()
    
}
