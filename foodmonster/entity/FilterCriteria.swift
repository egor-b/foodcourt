//
//  FilterCriteria.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 11/22/21.
//

import Foundation

struct FilterCriteria: Codable {
    
    var name: String = ""
    var minTime: String = ""
    var maxTime: String = ""
    var level: String = ""
    var type: String = ""
    var about: String = ""
    var lang: String = ""
    var ingredient: String = ""
    var userId: String = ""
    var isVisible: String = ""
}
