//
//  RecipeModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/20/21.
//

import Foundation

struct RecipeModel: Codable {
    
    var id: Int64 = 0
    var name: String = ""
    var time: Int = 0
    var serve: Int = 1
    var level: Double = 0.0
    var type: String = ""
    var about: String = "About"
    private(set) var timeStamp: Date? = Date()
    private(set) var userId: String = globalUserId
    var visible: String = "true"
    private(set) var lang: String? = "en"
    
    var food: [FoodModel] = []
    var step: [StepModel] = []
    var image: [ImageModel] = []
    
}
