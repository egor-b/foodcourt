//
//  PurchaseTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import UIKit

class FoodPurchaseTableViewCell: UITableViewCell {

    private var dataManger: DataNetworkManagerProtocol?
    @IBOutlet weak var purchaseLabel: UILabel!
    private var isInCart = false
    
    weak var viewModel: FoodPurchaseTableViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            let text = viewModel.food.name + " / " + String(describing: viewModel.food.amount) + " " + viewModel.food.unit
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            if viewModel.food.isAvailable {
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                purchaseLabel.attributedText = attributeString
            } else {
                attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
                purchaseLabel.attributedText = attributeString
            }
        }
    }
    
    func addedToCart(model: FoodPurchaseTableViewCellViewModel?, completion: @escaping (Error?) -> ()) {
        dataManger = DataNetworkManager()
        guard let dataManger = dataManger, let model = model else { return }
        let text = model.food.name + " / " + String(describing: model.food.amount) + " " + model.food.unit
        var isAdd = false
        if !model.food.isAvailable {
            isAdd = true
        }
        dataManger.updatePurchaseInCart(model.food.id, isAdd: isAdd) { error in
            if let error = error {
                completion(error)
            }
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            if !isAdd {
                attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
            } else {
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            }
            self.purchaseLabel.attributedText = attributeString
            completion(nil)
        }
        
        
    }

}
