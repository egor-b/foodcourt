//
//  EmailTableViewCell.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/26/22.
//

import UIKit

class EmailTableViewCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!

    weak var viewModel: UserProfileCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            email.text = "\(viewModel.user.email)"
        }
    }

}
