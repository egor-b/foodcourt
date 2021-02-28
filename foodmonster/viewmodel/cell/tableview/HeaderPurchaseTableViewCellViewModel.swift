//
//  PurchaseTableViewCellViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/19/20.
//

import Foundation

class HeaderPurchaseTableViewCellViewModel: HeaderPurchaseTableViewCellViewModelProtocol {
    var purchase: Purchase
    
    init(purchase: Purchase) {
        self.purchase = purchase
    }
}
