//
//  SaveRecipeTableViewCell.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/7/21.
//

import UIKit

class SaveRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var saveRecipeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveRecipeLable.text = Bundle.main.localizedString(forKey: "saveRecipe", value: LocalizationDefaultValues.SAVE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
