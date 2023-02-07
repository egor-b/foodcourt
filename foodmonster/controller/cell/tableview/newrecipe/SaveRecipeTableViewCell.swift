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
        let locale = NSLocale.current.languageCode
        if let locale = locale {
            if locale == "ru" {
                saveRecipeLable.text = "Сохранить рецепт"
            } else {
                saveRecipeLable.text = "Save recipe"
            }
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
