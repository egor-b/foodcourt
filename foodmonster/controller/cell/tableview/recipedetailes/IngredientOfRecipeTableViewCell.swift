//
//  IngredientOfRecipeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import UIKit

class IngredientOfRecipeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkMarkBoxButton: UIButton!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var countOfIngredientLabel: UILabel!
    
    private var networkManger: DataNetworkManagerProtocol?

    var purchase = PurchaseModel()

    weak var viewModel: IngredientTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            networkManger = DataNetworkManager()
            checkMarkBoxButton.addTarget(self, action: #selector(addToPurches), for: .touchUpInside)
            guard let viewModel = viewModel else { return }
            ingredientNameLabel?.text = viewModel.ingredient.product.name
            purchase.recipeName = viewModel.recipe.name
            purchase.recipeId = viewModel.recipe.id
            purchase.serve = viewModel.recipe.serve
            purchase.foodId = viewModel.ingredient.id
            purchase.amount = viewModel.ingredient.amount
            checkPurchase(viewModel.ingredient.id, viewModel.recipe.id)
            countOfIngredientLabel?.text = "\(viewModel.ingredient.amount) \(viewModel.ingredient.unit)"
        }
    }
    
    @objc func addToPurches(sender: UIButton) {
        guard let networkManger = networkManger else { return }
        if sender.currentImage == UIImage(named: "checkmark") {
            networkManger.deletePurchase(purchase, completion: { err in
                if let err = err {
                    print(err.localizedDescription)
                }
                UIView.transition(with: sender as UIView, duration: 0.5, options: .showHideTransitionViews, animations: {
                    sender.setImage(UIImage(named: "checkbox"), for: .normal)
                }, completion: nil)
            })
        } else {
            networkManger.addPurchase(purchase, completion: { err in
                UIView.transition(with: sender as UIView, duration: 0.5, options: .showHideTransitionViews, animations: {
                    sender.setImage(UIImage(named: "checkmark"), for: .normal)
                }, completion: nil)
            })
        }
    }
    
    func checkPurchase(_ foodId: Int64, _ recipeId: Int64) {
        guard let networkManger = networkManger else { return }
        networkManger.retreivePurchase(foodId, recipeId) { (purchase, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            if let purchase = purchase {
                self.purchase.id = purchase.id
                if !purchase.userId.isEmpty && !purchase.isAvailable {
                    UIView.transition(with: self.checkMarkBoxButton as UIView, duration: 0.5, options: .showHideTransitionViews, animations: {
                        self.checkMarkBoxButton.setImage(UIImage(named: "checkmark"), for: .normal)
                    }, completion: nil)
                }
            } else {
                UIView.transition(with:  self.checkMarkBoxButton as UIView, duration: 0.5, options: .showHideTransitionViews, animations: {
                    self.checkMarkBoxButton.setImage(UIImage(named: "checkbox"), for: .normal)
                }, completion: nil)
            }
            
        }
    }
    
}
