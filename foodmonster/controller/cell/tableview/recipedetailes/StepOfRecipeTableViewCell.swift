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
    @IBOutlet weak var stepImageHeighConstraint: NSLayoutConstraint!
    
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    private let step = Bundle.main.localizedString(forKey: "step", value: LocalizationDefaultValues.STEP.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    weak var viewModel: StepOfRecipeTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            spinnerView.startAnimating()
            guard let viewModel = viewModel else { return }
            firebaseStorage = FirebaseStorageServiceManager()
            stepDescriptionLabel?.text = "\(step) \(viewModel.step.stepNumber) \n" + viewModel.step.step
            if !viewModel.step.img.isEmpty && !viewModel.step.pic.isEmpty {
                self.stepImage.image = UIImage(data: viewModel.step.img)
                stepImageHeighConstraint.constant = 150
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
            } else if !viewModel.step.pic.isEmpty && viewModel.step.img.isEmpty {
                let ref = viewModel.step.pic
                firebaseStorage?.retreiveImage(ref, completion: { imageData in
                    self.stepImage.image = UIImage(data: imageData)
                    self.stepImageHeighConstraint.constant = 150
                    self.spinnerView.stopAnimating()
                    self.spinnerView.isHidden = true
                })
            } else {
                stepImageHeighConstraint.constant = 0
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
            }
            
        }
    }

}
