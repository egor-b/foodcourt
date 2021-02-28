//
//  HeaderPurchaseTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/19/20.
//

import UIKit

class HeaderPurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var serveLabel: UILabel!
    @IBOutlet weak var cornerImage: UIImageView!
    
    weak var viewModel: HeaderPurchaseTableViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            recipeNameLabel.text = viewModel.purchase.recipeName
            serveLabel.text = String(describing: viewModel.purchase.serve)
        }
    }

}
