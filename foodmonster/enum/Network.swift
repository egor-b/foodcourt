//
//  Network.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 11/21/21.
//

import Foundation

enum Network: String {
    case API_HOST = "http://localhost:8080"
    case CREATE_USER = "http://localhost:8080/v1/user/create"
    case SEARCH = "http://localhost:8080/v1/recipe/search"
    case SAVE = "http://localhost:8080/v1/recipe/save"
}
