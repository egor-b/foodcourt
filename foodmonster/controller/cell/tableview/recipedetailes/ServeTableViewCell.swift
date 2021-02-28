//
//  ServeTableViewCell.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit

class ServeTableViewCell: UITableViewCell {

    @IBOutlet weak var serveLabel: UILabel!
    @IBOutlet weak var changeServeStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
