//
//  PurchaseTableViewViewModelProtocol.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import UIKit

protocol PurchaseTableViewViewModelProtocol {
    
    func numberOfSection() -> Int
    func numberOfRows(inSection section: Int) -> Int
    func getHeaderForDishPurchaseList(forIndexPath indexPath: IndexPath) -> HeaderPurchaseTableViewCellViewModel?
    func cellPurchaseViewModel(forIndexPath indexPath: IndexPath) -> FoodPurchaseTableViewCellViewModel?
    func cellCustomPurchaseViewModel(forIndexPath indexPath: IndexPath) -> String?
    func viewForHeader(inSection section: Int, width: CGFloat, height: CGFloat) -> UIView
    
}
