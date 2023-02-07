//
//  PurchaseTableViewViewModel.swift
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
    
    func getPurchaseList(completion: @escaping() -> ())
    
    func getPurchase() -> [Purchase]
    func delteRecipePurchase(forSection section: Int, completion: @escaping(Error?) -> ())
    func updateCartPurchase(forIndexPath indexPath: IndexPath)
    
    func getPersonalPurchase() -> [String]
    func addPersonalItem(item: String)
    func removePersonalItem(forIndex item: Int)
    
}

class PurchaseTableViewViewModel: PurchaseTableViewViewModelProtocol {
    
    private var dataNetworkManager: DataNetworkManagerProtocol?
    private let userDefaults = UserDefaults.standard

    private let constant = Constant()
    private var customPurchase: [String] = []
    private var purchase: [Purchase] = []
    
    init() {
        dataNetworkManager = DataNetworkManager()
        customPurchase = userDefaults.object(forKey: "userPurchase") as? [String] ?? []
    }
    
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
    
    func getPurchaseList(completion: @escaping() -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        dataNetworkManager.retreivePurchaseList(completion: { [weak self] (list, err)  in
            if let err = err {
                print(err.localizedDescription)
                completion()
            }
            if let list = list {
                self?.purchase = list
            }
            completion()
        })
    }
    
    func getPurchase() -> [Purchase] {
        return purchase
    }
    
    func updateCartPurchase(forIndexPath indexPath: IndexPath) {
       let inCart = purchase[indexPath.section - 1].food[indexPath.row - 1].isAvailable
        if inCart {
            purchase[indexPath.section - 1].food[indexPath.row - 1].isAvailable = false
        } else {
            purchase[indexPath.section - 1].food[indexPath.row - 1].isAvailable = true
        }
    }
    
    func delteRecipePurchase(forSection section: Int, completion: @escaping(Error?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        let rid = purchase[section - 1].recipeId
        dataNetworkManager.deleteCartRecipePurchase(rid) { err in
            if let err = err {
                completion(err)
            }
            self.purchase.remove(at: section - 1)
            completion(nil)
        }
    }
    
    func getPersonalPurchase() -> [String] {
        return customPurchase
    }
    
    func addPersonalItem(item: String) {
        customPurchase.append(item)
        userDefaults.set(customPurchase, forKey: "userPurchase")
    }
    
    func removePersonalItem(forIndex item: Int) {
        customPurchase.remove(at: item)
        userDefaults.set(customPurchase, forKey: "userPurchase")
    }
}
