//
//  CathegoryTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import UIKit

class CathegoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var cathegoryCellView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?

    weak var viewModel: RecipeTableViewCellViewModelProtocol? {
        willSet(viewModel){
            spinnerView.startAnimating()
            guard let viewModel = viewModel else { return }
            firebaseStorage = FirebaseStorageServiceManager()
            dishNameLabel.text = viewModel.recipe.name
            cookingTimeLabel.text = String(describing: viewModel.recipe.time) + " min"
            if !viewModel.recipe.image.isEmpty {
                let ref = viewModel.recipe.image[0].pic
                firebaseStorage?.retreiveImage(ref, completion: { imageDate in
                    let image = UIImage(data: imageDate)
                    self.dishImage.image = image
                    self.spinnerView.stopAnimating()
                    self.spinnerView.isHidden = true
                })
            } else {
                self.dishImage.image = UIImage(named: "cook")
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
            }
            self.dishImage.addGradient()
        }
    }

    override func layoutSubviews() {
        cathegoryCellView.layer.cornerRadius = 5
    }
     
}
