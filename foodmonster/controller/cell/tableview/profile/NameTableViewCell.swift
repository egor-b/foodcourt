//
//  NameTableViewCell.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/26/22.
//

import UIKit

class NameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    weak var viewModel: UserProfileCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            nameLabel.text = "\(viewModel.user.name) \(viewModel.user.lastName)"
        }
    }

}
