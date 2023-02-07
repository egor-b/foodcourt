//
//  IngredientViewViewModelProtocol.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import Foundation

protocol IngredientTableViewCellViewModelProtocol: AnyObject {
    var ingredient: Food { get }
    var recipe: Recipe { get }
}
