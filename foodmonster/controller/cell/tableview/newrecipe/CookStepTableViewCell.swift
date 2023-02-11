//
//  CookStepTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/22/20.
//

import UIKit

class CookStepTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cookImageHeightConstraint: NSLayoutConstraint!
    
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        stepLabel.sizeToFit()
        setImage()
        // Initialization code
    }

    weak var viewModel: NewStepTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            stepLabel.text = String(viewModel.step.stepNumber) + ". " + viewModel.step.step
            if viewModel.step.pic.count > 1 {
                if viewModel.step.img.isEmpty {
                    firebaseStorage = FirebaseStorageServiceManager()
                    let ref = viewModel.step.pic
                    firebaseStorage?.retreiveImage(ref, completion: { imageData in
                        self.stepImageView.image = UIImage(data: imageData)
                    })
                } else {
                    stepImageView.image = UIImage(data: viewModel.step.img)
                }
            } else {
                imageHeightConstraint.constant = 0
                cookImageHeightConstraint.constant = 0
                stepImageView.image = nil
            }
        }
    }
    
    func setImage() {
        stepImageView.layer.masksToBounds = true
        stepImageView.layer.cornerRadius = 10
        
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowRadius = 8.0
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 4, height: 4)
    }

}
