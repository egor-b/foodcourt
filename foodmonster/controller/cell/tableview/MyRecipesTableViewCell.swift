//
//  MyRecipesTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/17/20.
//

import UIKit

class MyRecipesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var attensionSignImage: UIImageView!
    
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    
    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            spinnerView.startAnimating()
            guard let viewModel = viewModel else { return }
            firebaseStorage = FirebaseStorageServiceManager()
            recipeNameLabel.text = viewModel.recipe.name
            typeLabel.text = viewModel.recipe.type
            cookingTimeLabel.text = String(describing: viewModel.recipe.time) + " min"
            if !viewModel.recipe.image.isEmpty {
                let ref = viewModel.recipe.image[0].pic
                self.firebaseStorage?.retreiveImage(ref, completion: { imageDate in
                    let image = UIImage(data: imageDate)
                    self.recipeImage.image = image
                    self.spinnerView.stopAnimating()
                    self.spinnerView.isHidden = true
                    
                })
                
            } else {
                self.recipeImage.image = UIImage(named: "cook")
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
            }
            self.recipeImage.addGradient()
            isShowAttinsionSign(isVisiable: viewModel.recipe.visible )
        }
    }
    
    override func layoutSubviews() {
        recipeCellView.layer.cornerRadius = 7.5
    }
    
    private func isShowAttinsionSign(isVisiable: String) {
        if isVisiable == "true" {
            attensionSignImage.isHidden = true
        } else {
            attensionSignImage.isHidden = false
        }
    }
}
