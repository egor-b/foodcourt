//
//  User.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/28/21.
//

import Foundation

struct User: Codable {
    
    var id: Int64 = 0
    var uid: String = ""
    var email: String = ""
    var nickname: String = ""
    var name: String = ""
    var lastName: String = ""
    var country: String = ""
    var isDisable: Bool = false
    var pic: String = ""
    var accountType: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case name
        case lastName = "lname"
        case email
        case country
        case pic = "pic"
        case nickname = "username"
        case isDisable = "disable"
        case accountType = "accountType"
    }
    
    init(email: String, nickname: String = "", name: String, lastName: String, role: String? = "USER", isDisable: Bool = false, accountType: String = "") {
        self.email = email
        self.nickname = nickname
        self.name = name
        self.lastName = lastName
        self.country = Locale.current.regionCode ?? "none"
        self.isDisable = isDisable
        self.accountType = accountType
        
    }
    
    init(uid: String, email: String, nickname: String = "", name: String, lastName: String, role: String = "USER", isDisable: Bool = false, pic: String, accountType: String) {
        self.uid = uid
        self.email = email
        self.nickname = nickname
        self.name = name
        self.lastName = lastName
        self.country = Locale.current.regionCode ?? "none"
        self.isDisable = isDisable
        self.pic = pic
        self.accountType = accountType
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let uid = try values.decode(String?.self, forKey: .uid) {
            self.uid = uid
        }
        if let email = try values.decode(String?.self, forKey: .email) {
            self.email = email
        }
        if let nickname = try values.decode(String?.self, forKey: .nickname) {
            self.nickname = nickname
        }
        if let name = try values.decode(String?.self, forKey: .name) {
            self.name = name
        }
        if let lastName = try values.decode(String?.self, forKey: .lastName) {
            self.lastName = lastName
        }
        if let country = try values.decode(String?.self, forKey: .country) {
            self.country = country
        }
        if let pic = try values.decode(String?.self, forKey: .pic) {
            self.pic = pic
        }
        if let isDisable = try values.decode(Bool?.self, forKey: .isDisable) {
            self.isDisable = isDisable
        }
        
        if let accountType = try values.decode(String?.self, forKey: .accountType) {
            self.accountType = accountType
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(name, forKey: .name)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(country, forKey: .country)
        try container.encode(pic, forKey: .pic)
        try container.encode(isDisable, forKey: .isDisable)
        try container.encode(accountType, forKey: .accountType)
    }
    
    
    
}
