//
//  Recipe.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

struct Recipe {
    
    var name: String
    var time: Int
    var serve: Int
    var level: Double
    var type: String
    var about: String
    private(set) var timaStamp: Date?
//    private(set) var user_id: Int64
    var visible: Bool
    private(set) var lang: String?
    
    var food: [Food]
    var step: [Step]
//    var image: [String]
    
    
    init(name: String, time: Int, serve: Int, level: Double, type: String, about: String, visible: Bool, food: [Food], step: [Step]/*, image: [String]*/) {
        
        self.name = name
        self.time = time
        self.serve = serve
        self.level = level
        self.type = type
        self.about = about
        self.visible = visible
        self.food = food
        self.step = step
//        self.image = image
        
        self.timaStamp = Date()
        self.lang = Locale.current.languageCode
    }
    
}
