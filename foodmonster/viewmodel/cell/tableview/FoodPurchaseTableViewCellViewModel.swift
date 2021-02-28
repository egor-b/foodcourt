//
//  PurchaseTableViewCellViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import Foundation

class FoodPurchaseTableViewCellViewModel: FoodPurchaseTableViewCellViewModelProtocol {
    var food: Food
    
    init(purchases: Food) {
        self.food = purchases
    }
    
}
