//
//  StepOfRecipeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/10/20.
//

import UIKit

class StepOfRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var stepDescriptionLabel: UILabel!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    
    weak var viewModel: StepOfRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            spinnerView.startAnimating()
            guard let viewModel = viewModel else { return }
            firebaseStorage = FirebaseStorageServiceManager()
            stepDescriptionLabel?.text = "STEP \(viewModel.step.stepNumber). \n" + viewModel.step.step
            if viewModel.step.pic.count > 1 {
                let ref = viewModel.step.pic
                firebaseStorage?.retreiveImage(ref, completion: { imageData in
                    self.stepImage.image = UIImage(data: imageData)
                    self.spinnerView.stopAnimating()
                    self.spinnerView.isHidden = true
                })
            } else {
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
            }
        }
    }

}
