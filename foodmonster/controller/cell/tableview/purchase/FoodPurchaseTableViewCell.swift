//
//  PurchaseTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import UIKit

class FoodPurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var purchaseLabel: UILabel!
    
    weak var viewModel: FoodPurchaseTableViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            purchaseLabel.text = viewModel.food.name + " / " + String(describing: viewModel.food.count) + " " + viewModel.food.messuer
        }
    }

}
