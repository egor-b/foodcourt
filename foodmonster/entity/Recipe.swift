//
//  Recipe.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

struct Recipe: Codable {
    
    var id: Int64 = 0
    var name: String = ""
    var time: Int = 0
    var serve: Int = 0
    var level: Double = 0.0
    var type: String = "Dessert"
    var about: String = "About"
    private(set) var timestamp: Date = Date()
    private(set) var userId: String = ""
    var visible: String = "true"
    private(set) var lang: String = "en"
    
    var food: [Food] = []
    var step: [Step] = []
    var image: [Image] = []
    
    internal init() {

    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case time = "time"
        case serve = "serve"
        case level = "level"
        case type = "type"
        case about = "about"
        case timestamp = "date"
        case userId = "userId"
        case visible = "visible"
        case lang = "lang"
        case food = "food"
        case step = "step"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try values.decodeIfPresent(Int64.self, forKey: .id) {
            self.id = id
        }
        if let name = try values.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        }
        if let time = try values.decodeIfPresent(Int.self, forKey: .time) {
            self.time = time
        }
        if let serve = try values.decodeIfPresent(Int.self, forKey: .serve){
            self.serve = serve
        }
        if let level = try values.decodeIfPresent(Double.self, forKey: .level) {
            self.level = level
        }
        if let type = try values.decodeIfPresent(String.self, forKey: .type) {
            self.type = type
        }
        if let about = try values.decodeIfPresent(String.self, forKey: .about) {
            self.about = about
        }
        if let timestamp = try values.decodeIfPresent(Date.self, forKey: .timestamp) {
            self.timestamp = timestamp
        }
        if let userId = try values.decodeIfPresent(String.self, forKey: .userId) {
            self.userId = userId
        }
        if let visible = try values.decodeIfPresent(String.self, forKey: .visible) {
            self.visible = visible
        }
        if let lang = try values.decodeIfPresent(String.self, forKey: .lang) {
            self.lang = lang
        }
        
        if let food = try values.decodeIfPresent([Food].self, forKey: .food) {
            self.food = food
        }
        if let step = try values.decodeIfPresent([Step].self, forKey: .step) {
            self.step = step
        }
        if let image = try values.decodeIfPresent([Image].self, forKey: .image) {
            self.image = image
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(time, forKey: .time)
        try container.encode(serve, forKey: .serve)
        try container.encode(level, forKey: .level)
        try container.encode(type, forKey: .type)
        try container.encode(about, forKey: .about)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(userId, forKey: .userId)
        try container.encode(visible, forKey: .visible)
        try container.encode(lang, forKey: .lang)
        
        try container.encode(food, forKey: .food)
        try container.encode(step, forKey: .step)
        try container.encode(image, forKey: .image)
        
    }
    
}
