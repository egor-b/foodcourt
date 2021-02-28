//
//  PurchaseTableViewViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import UIKit

class PurchaseTableViewViewModel: PurchaseTableViewViewModelProtocol {
    
//    private var purchase = [Purchase]()
    private let constant = Constant()
    private var customPurchase = ["dsfjhebrf", "sdfkjd"]
    private var purchase = [Purchase(recipeName: "Potatoes", serve: 5, recipeId: 651, food: [Food(name: "123", count: 2.3, messuer: "eee"),
                                                                            Food(name: "dseg", count: 2.3, messuer: "eergee"),
                                                                            Food(name: "14df23", count: 2.3, messuer: "ef3ee")]),
                            Purchase(recipeName: "Rice", serve: 3, recipeId: 651, food: [Food(name: "1111", count: 2.3, messuer: "eee"),
                                                                                                    Food(name: "22222", count: 2.3, messuer: "eergee"),
                                                                                                    Food(name: "33333", count: 2.3, messuer: "ef3ee")])]
//
    func numberOfSection() -> Int {
        return purchase.count + 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if section == 0 {
            return customPurchase.count + 1
        } else {
            return purchase[section - 1].food.count + 1
        }
    }
    
    func getHeaderForDishPurchaseList(forIndexPath indexPath: IndexPath) -> HeaderPurchaseTableViewCellViewModel? {
        return HeaderPurchaseTableViewCellViewModel(purchase: purchase[indexPath.section - 1])
    }
    
    func cellPurchaseViewModel(forIndexPath indexPath: IndexPath) -> FoodPurchaseTableViewCellViewModel? {
        return FoodPurchaseTableViewCellViewModel(purchases: purchase[indexPath.section - 1].food[indexPath.row - 1])
    }
    
    func cellCustomPurchaseViewModel(forIndexPath indexPath: IndexPath) -> String? {
        return customPurchase[indexPath.row]
    }
    
    func viewForHeader(inSection section: Int, width: CGFloat, height: CGFloat) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        if section == 0 {
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width - 50, height: headerView.frame.height))
            label.text = "Extra items"
            label.textColor = UIColor(named: "lightTextColorSet")
            headerView.addSubview(label)
        }
        headerView.backgroundColor = constant.backgoundColor
        return headerView
    }
}
